//
//  SettingsViewController.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 22.07.2025.
//

import UIKit
import RxSwift

final class SettingsViewController: UIViewController {
    private lazy var mainView = SettingsView()
    
    private lazy var viewModel = SettingsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: SettingsViewModel.Input(
            didTapAuroraAlerts: mainView.auroraAlertsButton.rx.tap.asSignal(),
            didTapLocation: mainView.locationButton.rx.tap.asSignal(),
            didTapTermsOfUse: mainView.termsOfUseButton.rx.tap.asSignal(),
            didTapPrivacyPolicy: mainView.privacyPoliceButton.rx.tap.asSignal(),
            didTapSupport: mainView.supportButton.rx.tap.asSignal()
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension SettingsViewController {
    static func make() -> SettingsViewController {
        let vc = SettingsViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "Settings.Title".localized
        return vc
    }
}

// MARK: Private
private extension SettingsViewController {
    func action(_ action: SettingsViewModel.Action) {
        switch action {
        case .openAuroraAlerts:
            let vc = SettingsAlertsViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .openLocation:
            let vc = SettingsLocationViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .openUrl(let url):
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
