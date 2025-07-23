//
//  OnboardingViewModel.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 16.07.2025.
//

import RxSwift
import RxCocoa

final class OnboardingViewModel {
    enum Action {
        case paygateTransitionMain, main
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension OnboardingViewModel {
    struct Input {
        let didCombineData: Signal<OnboardingCombineData.CombineData>
    }
    
    struct Output {
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(didCombineData: input.didCombineData)
        )
    }
}

// MARK: Private
private extension OnboardingViewModel {
    func makeAction(didCombineData: Signal<OnboardingCombineData.CombineData>) -> Driver<Action> {
        didCombineData
            .flatMapLatest { [weak self] data -> Driver<Action> in
                guard let self else { return .never() }
                
                func source() -> Single<Action> {
                    let profile = Profile(
                        notificationToken: data.notificationsToken,
                        kpThresholdEnabled: false,
                        cloudBreakEnabled: false,
                        location: data.location
                    )
                    
                    return profileManager
                        .setup(profile: profile)
                        .map { result -> Action in
                            guard result.success else {
                                throw ContentError(.notContent)
                            }
                            
                            return SessionManager().hasActiveSubscriptions() ? .main : .paygateTransitionMain
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
    }
}
