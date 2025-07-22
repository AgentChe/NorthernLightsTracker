//
//  SettingsLocationViewModel.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 22.07.2025.
//

import RxSwift
import RxCocoa

final class SettingsLocationViewModel {
    enum Action {
        case setupRecent(String)
        case close
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    private lazy var locationManager = LocationManager()
    private lazy var profileManager = ProfileManager()
}

// MARK: Public
extension SettingsLocationViewModel {
    struct Input {
        let changedText: Signal<String>
        let didScrollToBottom: Signal<Void>
        let didSelectRecent: Signal<String>
        let didSelectLocation: Signal<Location> 
    }
    
    struct Output {
        let elements: Driver<[SettingsLocationTableElement]>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        let history = makeHistory()
        
        return Output(
            elements: makeElements(
                changedText: input.changedText,
                history: history,
                didScrollToBottom: input.didScrollToBottom
            ),
            action: makeAction(
                didSelectRecent: input.didSelectRecent,
                didSelectLocation: input.didSelectLocation
            )
        )
    }
}

// MARK: Private
private extension SettingsLocationViewModel {
    func makeElements(
        changedText: Signal<String>,
        history: Driver<LocationHistory?>,
        didScrollToBottom: Signal<Void>
    ) -> Driver<[SettingsLocationTableElement]> {
        enum Source: Hashable {
            case history
            case search(String)
        }
        
        let source = changedText
            .debounce(RxTimeInterval.milliseconds(500))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Source.history : Source.search($0) }
            .asDriver(onErrorDriveWith: .never())
            .distinctUntilChanged()
        
        return Driver
            .combineLatest(source, history)
            .flatMapLatest { [weak self] source, history -> Driver<[SettingsLocationTableElement]> in
                guard let self else { return .never() }
                
                switch source {
                case .history:
                    var elements = [SettingsLocationTableElement]()
                    
                    if let current = history?.current {
                        elements.append(.currentLocation(current))
                    }
                    
                    if let recent = history?.recentSearch, !recent.isEmpty {
                        elements.append(.recentTitle)
                        recent.forEach { elements.append(.recent($0)) }
                    }
                    
                    return .just(elements)
                case .search(let text):
                    return self.makeLocations(
                        text: text,
                        didScrollToBottom: didScrollToBottom
                    )
                    .map { locations -> [SettingsLocationTableElement] in
                        locations.map { .location($0) }
                    }
                }
            }
    }
    
    func makeHistory() -> Driver<LocationHistory?> {
        locationManager
            .obtainHistory()
            .asDriver(onErrorJustReturn: nil)
    }
    
    func makeLocations(
        text: String,
        didScrollToBottom: Signal<Void>
    ) -> Driver<[Location]> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int, text: String) -> Driver<Page<[Location]>> {
            locationManager
                .searchLocations(text: text, page: page)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let firstPage = fetch(page: 1, text: text)
        
        let downloadPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[Location]>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .compactMap { lastPageInfo }
                    .filter { ($0.nextPage <= $0.total) && ($0.current != $0.total) }
                    .flatMapFirst { lastPageInfo -> Driver<Page<[Location]>> in
                        fetch(page: lastPageInfo.nextPage, text: text)
                    }
                    .startWith(firstPage)
            }
        
        return downloadPage
            .scan([]) { currentLocations, page -> [Location] in
                page.info.current == 1 ? page.elements : (currentLocations + page.elements)
            }
    }
    
    func makeAction(
        didSelectRecent: Signal<String>,
        didSelectLocation: Signal<Location>
    ) -> Driver<Action> {
        let setupRecent = didSelectRecent
            .map { Action.setupRecent($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let updateLocation = didSelectLocation
            .flatMapLatest { [weak self] location -> Driver<Action> in
                guard let self else { return .never() }
                
                func source() -> Single<Action> {
                    profileManager
                        .update(geoId: location.id)
                        .map { result -> Action in
                            guard result.success else {
                                throw ContentError(.notContent)
                            }
                            
                            return .close
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    tryAgain?(error) ?? .empty()
                }

                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(setupRecent, updateLocation)
    }
}
