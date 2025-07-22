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
    }
}

// MARK: Public
extension NowViewModel {
    struct Input {
        let didTapSettings: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(didTapSettings: input.didTapSettings)
        )
    }
}

// MARK: Private
private extension NowViewModel {
    func makeAction(
        didTapSettings: Signal<Void>
    ) -> Driver<Action> {
        let openSettings = didTapSettings
            .map { Action.openSettings }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(openSettings)
    }
}
