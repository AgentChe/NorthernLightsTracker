//
//  SettingsAlertsViewController.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 22.07.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingsAlertsViewController: UIViewController {
    private lazy var mainView = SettingsAlertsView()
    
    private lazy var viewModel = SettingsAlertsViewModel()
    
    private lazy var didTapKPTrigger = PublishRelay<Bool>()
    private lazy var didTapCloudBreakTrigger = PublishRelay<Bool>()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            self?.open(error: error) ?? .never()
        }
        
        let output = viewModel.configure(input: SettingsAlertsViewModel.Input(
            didTapKP: didTapKPTrigger.asSignal(),
            didTapCloudBreak: didTapCloudBreakTrigger.asSignal()
        ))
        
        let kp = output.kp
        let cloudBreak = output.cloudBreak
        
        kp.drive(Binder(mainView.kpButton) { base, enable in
            base.switchView.setOn(enable, animated: true)
        })
        .disposed(by: disposeBag)
        
        cloudBreak.drive(Binder(mainView.cloudBreakButton) { base, enable in
            base.switchView.setOn(enable, animated: true)
        })
        .disposed(by: disposeBag)
        
        mainView.kpButton.rx.tap
            .asSignal(onErrorSignalWith: .never())
            .withLatestFrom(kp)
            .emit(to: didTapKPTrigger)
            .disposed(by: disposeBag)
        
        mainView.cloudBreakButton.rx.tap
            .asSignal(onErrorSignalWith: .never())
            .withLatestFrom(cloudBreak)
            .emit(to: didTapCloudBreakTrigger)
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(mainView) { base, activity in
                base.kpButton.isUserInteractionEnabled = !activity
                base.cloudBreakButton.isUserInteractionEnabled = !activity
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension SettingsAlertsViewController {
    static func make() -> SettingsAlertsViewController {
        let vc = SettingsAlertsViewController()
        vc.navigationItem.title = "SettingsAlerts.Title".localized
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension SettingsAlertsViewController {
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self else { return Disposables.create() }
                
                let vc = TryAgainViewController.make(error: error) {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}
