//
//  NowViewController.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 22.07.2025.
//

import UIKit
import RxSwift

final class NowViewController: UIViewController {
    private lazy var mainView = NowView()
    
    private lazy var viewModel = NowViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: NowViewModel.Input(
            didTapSettings: mainView.titleView.settingsButton.rx.tap.asSignal()
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: Public
extension NowViewController {
    static func make() -> NowViewController {
        let vc = NowViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension NowViewController {
    func action(_ action: NowViewModel.Action) {
        switch action {
        case .openSettings:
            let vc = SettingsViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
