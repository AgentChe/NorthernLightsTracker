//
//  SettingsViewModel.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 22.07.2025.
//

import RxSwift
import RxCocoa

final class SettingsViewModel {
    enum Action {
        case openAuroraAlerts
        case openLocation
        case openUrl(URL)
    }
}

// MARK: Public
extension SettingsViewModel {
    struct Input {
        let didTapAuroraAlerts: Signal<Void>
        let didTapLocation: Signal<Void>
        let didTapTermsOfUse: Signal<Void>
        let didTapPrivacyPolicy: Signal<Void>
        let didTapSupport: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(
                didTapAuroraAlerts: input.didTapAuroraAlerts,
                didTapLocation: input.didTapLocation,
                didTapTermsOfUse: input.didTapTermsOfUse,
                didTapPrivacyPolicy: input.didTapPrivacyPolicy,
                didTapSupport: input.didTapSupport
            )
        )
    }
}

// MARK: Private
private extension SettingsViewModel {
    func makeAction(
        didTapAuroraAlerts: Signal<Void>,
        didTapLocation: Signal<Void>,
        didTapTermsOfUse: Signal<Void>,
        didTapPrivacyPolicy: Signal<Void>,
        didTapSupport: Signal<Void>
    ) -> Driver<Action> {
        let openAuroraAlerts = didTapAuroraAlerts
            .map { Action.openAuroraAlerts }
            .asDriver(onErrorDriveWith: .never())
        
        let openLocation = didTapLocation
            .map { Action.openLocation }
            .asDriver(onErrorDriveWith: .never())
        
        let openTermsOfUse = didTapTermsOfUse
            .map { Action.openUrl(GlobalDefinitions.termsOfServiceUrl) }
            .asDriver(onErrorDriveWith: .never())
        
        let openPrivacyPolicy = didTapPrivacyPolicy
            .map { Action.openUrl(GlobalDefinitions.privacyPolicyUrl) }
            .asDriver(onErrorDriveWith: .never())
        
        let openSupport = didTapSupport
            .map { Action.openUrl(GlobalDefinitions.contactUsUrl) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(
                openAuroraAlerts,
                openLocation,
                openTermsOfUse,
                openPrivacyPolicy,
                openSupport
            )
    }
}
