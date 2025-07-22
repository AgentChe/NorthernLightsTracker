//
//  SettingsAlertsViewModel.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 22.07.2025.
//

import RxSwift
import RxCocoa

final class SettingsAlertsViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension SettingsAlertsViewModel {
    struct Input {
        let didTapKP: Signal<Bool>
        let didTapCloudBreak: Signal<Bool>
    }
    
    struct Output {
        let activity: Driver<Bool>
        let kp: Driver<Bool>
        let cloudBreak: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let activity = RxActivityIndicator()
        
        return Output(
            activity: activity.asDriver(),
            kp: makeKP(
                didTapKP: input.didTapKP,
                activity: activity
            ),
            cloudBreak: makeCloudBreak(
                didTapCloudBreak: input.didTapCloudBreak,
                activity: activity
            )
        )
    }
}

// MARK: Private
private extension SettingsAlertsViewModel {
    func makeKP(didTapKP: Signal<Bool>, activity: RxActivityIndicator) -> Driver<Bool> {
        let initial = profileManager
            .obtainProfile(forceUpdate: false)
            .map { $0?.kpThresholdEnabled ?? false }
            .asDriver(onErrorJustReturn: false)
        
        let update = didTapKP
            .flatMapFirst { [weak self] enable -> Driver<Bool> in
                guard let self else { return .never() }
                
                func source() -> Single<Bool> {
                    profileManager
                        .update(kpThresholdEnabled: !enable)
                        .map { result -> Bool in
                            guard result.success else {
                                throw ContentError(.notContent)
                            }
                            
                            return !enable
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
                    .trackActivity(activity)
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(initial, update)
    }
    
    func makeCloudBreak(didTapCloudBreak: Signal<Bool>, activity: RxActivityIndicator) -> Driver<Bool> {
        let initial = profileManager
            .obtainProfile(forceUpdate: false)
            .map { $0?.cloudBreakEnabled ?? false }
            .asDriver(onErrorJustReturn: false)
        
        let update = didTapCloudBreak
            .flatMapFirst { [weak self] enable -> Driver<Bool> in
                guard let self else { return .never() }
                
                func source() -> Single<Bool> {
                    profileManager
                        .update(cloudBreakEnabled: !enable)
                        .map { result -> Bool in
                            guard result.success else {
                                throw ContentError(.notContent)
                            }
                            
                            return !enable
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
                    .trackActivity(activity)
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(initial, update)
    }
}
