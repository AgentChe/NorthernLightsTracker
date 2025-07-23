//
//  NowViewModel.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 22.07.2025.
//

import RxSwift
import RxCocoa

final class NowViewModel {
    enum Action {
        case openSettings
        case changeLocation
        case openFullMap
        case openTopLocations
        case openPaygate
    }
    
    private lazy var profileManager = ProfileManager()
    private lazy var auroraManager = AuroraManager()
}

// MARK: Public
extension NowViewModel {
    struct Input {
        let didTapSettings: Signal<Void>
        let didTapLocation: Signal<Void>
        let didTapOpenFullMap: Signal<Void>
        let didTapOpenTopLocations: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
        let currentLocation: Driver<Location?>
        let elements: Driver<[NowTableElement]>
    }
    
    func configure(input: Input) -> Output {
        let auroraNow = makeAuroraNow()
        let hasTopLocations = makeHasTopLocations()
        let currentLocation = makeCurrentLocation()
        
        return Output(
            action: makeAction(
                didTapSettings: input.didTapSettings,
                didTapLocation: input.didTapLocation,
                didTapOpenFullMap: input.didTapOpenFullMap,
                didTapOpenTopLocations: input.didTapOpenTopLocations
            ),
            currentLocation: currentLocation,
            elements: makeElements(
                auroraNow: auroraNow,
                hasTopLocations: hasTopLocations,
                currentLocation: currentLocation
            )
        )
    }
}

// MARK: Private
private extension NowViewModel {
    func makeAction(
        didTapSettings: Signal<Void>,
        didTapLocation: Signal<Void>,
        didTapOpenFullMap: Signal<Void>,
        didTapOpenTopLocations: Signal<Void>
    ) -> Driver<Action> {
        let openSettings = didTapSettings
            .map { Action.openSettings }
            .asDriver(onErrorDriveWith: .never())
        
        let changeLocation = didTapLocation
            .map { Action.changeLocation }
            .asDriver(onErrorDriveWith: .never())
        
        let openFullMap = didTapOpenFullMap
            .map { Action.openFullMap }
            .asDriver(onErrorDriveWith: .never())
        
        let openTopLocations = didTapOpenTopLocations
            .map { SessionManager().hasActiveSubscriptions() ? Action.openTopLocations : Action.openPaygate }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(openSettings, changeLocation, openFullMap, openTopLocations)
    }
    
    func makeElements(
        auroraNow: Driver<AuroraNow?>,
        hasTopLocations: Driver<Bool?>,
        currentLocation: Driver<Location?>
    ) -> Driver<[NowTableElement]> {
        Driver
            .combineLatest(auroraNow, hasTopLocations, currentLocation)
            .map { auroraNow, hasTopLocations, currentLocation -> [NowTableElement] in
                var elements = [NowTableElement]()
                
                if let updated = auroraNow?.updatedTime {
                    elements.append(.updated(updated))
                }
                
                if let status = auroraNow?.status {
                    elements.append(.status(status))
                }
                
                let indicators = NowTableIndicatorsElement(
                    cloudCover: auroraNow?.cloudCover,
                    kpIndex: auroraNow?.kpIndex,
                    peakTime: auroraNow?.peakTime
                )
                elements.append(.indicators(indicators))
                
                elements.append(.openMapRoute)
                
                if let currentLocation {
                    elements.append(.currentLocation(currentLocation))
                }
                
                if let hasTopLocations {
                    elements.append(hasTopLocations ? .topLocationsRoute : .noTopLocations)
                }
                
                return elements
            }
    }
    
    func makeAuroraNow() -> Driver<AuroraNow?> {
        ProfileMediator.shared
            .didChangeLocation
            .map { _ in Void() }
            .startWith(())
            .flatMapLatest { [weak self] void -> Driver<AuroraNow?> in
                guard let self else { return .never() }
                
                return auroraManager
                    .obtainAuroraNow()
                    .asDriver(onErrorJustReturn: nil)
            }
    }
    
    func makeHasTopLocations() -> Driver<Bool?> {
        auroraManager
            .obtainAuroraTopLocations()
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: nil)
            .startWith(nil)
    }
    
    func makeCurrentLocation() -> Driver<Location?> {
        let initial = profileManager
            .obtainProfile(forceUpdate: false)
            .map { $0?.location }
            .asDriver(onErrorDriveWith: .never())
        
        let updated = ProfileMediator.shared
            .didChangeLocation
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(initial, updated)
    }
}
