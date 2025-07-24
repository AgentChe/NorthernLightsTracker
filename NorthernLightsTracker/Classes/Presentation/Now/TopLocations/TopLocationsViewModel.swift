//
//  TopLocationsViewModel.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 23.07.2025.
//

import RxSwift
import RxCocoa

final class TopLocationsViewModel {
    private lazy var auroraManager = AuroraManager()
}

// MARK: Public
extension TopLocationsViewModel {
    struct Input {
        let didSelect: Signal<AuroraTopLocation>
    }
    
    struct Output {
        let elements: Driver<[TopLocationsCollectionElement]>
        let selectedLocation: Driver<AuroraTopLocation>
    }
    
    func configure(input: Input) -> Output {
        let elements = makeElements()
        
        return Output(
            elements: elements,
            selectedLocation: makeSelectedLocation(
                elements: elements,
                didSelect: input.didSelect
            )
        )
    }
}

// MARK: Private
private extension TopLocationsViewModel {
    func makeElements() -> Driver<[TopLocationsCollectionElement]> {
        auroraManager
            .obtainAuroraTopLocations()
            .asDriver(onErrorJustReturn: [])
            .map { topLocations -> [TopLocationsCollectionElement] in
                topLocations.enumerated().map { index, topLocation -> TopLocationsCollectionElement in
                    TopLocationsCollectionElement(
                        location: topLocation,
                        selected: index == 0
                    )
                }
            }
    }
    
    func makeSelectedLocation(
        elements: Driver<[TopLocationsCollectionElement]>,
        didSelect: Signal<AuroraTopLocation>
    ) -> Driver<AuroraTopLocation> {
        let initial = elements.compactMap { elements -> AuroraTopLocation? in
            elements.first(where: { $0.selected })?.location
        }
        
        let selected = didSelect.asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(initial, selected)
    }
}
