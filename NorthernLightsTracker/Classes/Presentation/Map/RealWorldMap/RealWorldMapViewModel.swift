//
//  RealWorldMapViewModel.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 28.07.2025.
//

import RxSwift
import RxCocoa

final class RealWorldMapViewModel {
    enum Action {
        case moveToMyGeo
    }
    
    private lazy var auroraManager = AuroraManager()
}

// MARK: Public
extension RealWorldMapViewModel {
    struct Input {
        let didTapMyGeo: Signal<Void>
        let didTapCoordinate: Signal<Coordinate>
    }
    
    struct Output {
        let action: Driver<Action>
        let annotation: Driver<TopLocationAnnotation?>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(didTapMyGeo: input.didTapMyGeo),
            annotation: makeAnnotation(didTapCoordinate: input.didTapCoordinate)
        )
    }
}

// MARK: Private
private extension RealWorldMapViewModel {
    func makeAction(didTapMyGeo: Signal<Void>) -> Driver<Action> {
        let moveToMyGeo = didTapMyGeo
            .map { Action.moveToMyGeo }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(moveToMyGeo)
    }
    
    func makeAnnotation(didTapCoordinate: Signal<Coordinate>) -> Driver<TopLocationAnnotation?> {
        didTapCoordinate
            .flatMapLatest { [weak self] coordinate -> Driver<TopLocationAnnotation?> in
                guard let self else { return .never() }
                
                return auroraManager
                    .obtainAuroraMapDetails(coordinate: coordinate)
                    .map { details -> TopLocationAnnotation? in
                        guard let details else { return nil }
                        
                        return TopLocationAnnotation(mapDetails: details)
                    }
                    .asDriver(onErrorJustReturn: nil)
                    .startWith(nil)
            }
    }
}
