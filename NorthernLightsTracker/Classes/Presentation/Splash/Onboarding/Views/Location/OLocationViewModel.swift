//
//  OLocationViewModel.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 16.07.2025.
//

import RxSwift
import RxCocoa

final class OLocationViewModel {
    enum Action {
        case next(Location)
    }
    
    private lazy var locationManager = LocationManager()
}

// MARK: Public
extension OLocationViewModel {
    struct Input {
        let changedText: Signal<String>
        let didScrollToBottom: Signal<Void>
        let didSelectLocation: Signal<Location>
    }
    
    struct Output {
        let locations: Driver<[Location]>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            locations: makeLocations(
                changedText: input.changedText,
                didScrollToBottom: input.didScrollToBottom
            ),
            action: makeAction(didSelectLocation: input.didSelectLocation)
        )
    }
}

// MARK: Private
private extension OLocationViewModel {
    func makeLocations(
        changedText: Signal<String>,
        didScrollToBottom: Signal<Void>
    ) -> Driver<[Location]> {
        var lastPageInfo: PageInfo?
        
        let text = changedText
            .asDriver(onErrorDriveWith: .never())
            .distinctUntilChanged()
        
        func fetch(page: Int, text: String) -> Driver<Page<[Location]>> {
            locationManager
                .searchLocations(text: text, page: page)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let firstPage = text
            .debounce(RxTimeInterval.milliseconds(500))
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .flatMapLatest { text -> Driver<Page<[Location]>> in
                fetch(page: 1, text: text)
            }
        
        let downloadPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[Location]>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .withLatestFrom(text)
                    .compactMap { text -> (String, PageInfo)? in
                        guard let lastPageInfo else { return nil }
                        return (text, lastPageInfo)
                    }
                    .filter { ($1.nextPage <= $1.total) && ($1.current != $1.total) }
                    .flatMapFirst { text, lastPageInfo -> Driver<Page<[Location]>> in
                        fetch(page: lastPageInfo.nextPage, text: text)
                    }
                    .startWith(firstPage)
            }
        
        let downloadLocations = downloadPage
            .scan([]) { currentLocations, page -> [Location] in
                page.info.current == 1 ? page.elements : (currentLocations + page.elements)
            }
        
        let resetLocations = text
            .filter { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .map { _ -> [Location] in [] }
            .asDriver(onErrorJustReturn: [])
        
        return Driver
            .merge(downloadLocations, resetLocations)
    }
    
    func makeAction(didSelectLocation: Signal<Location>) -> Driver<Action> {
        didSelectLocation
            .map { Action.next($0) }
            .asDriver(onErrorDriveWith: .never())
    }
}
