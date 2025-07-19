//
//  SolarListViewController.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 18.07.2025.
//

import UIKit
import RxSwift

final class SolarListViewController: UIViewController {
    private lazy var mainView = SolarListView()
    
    private lazy var viewModel = SolarListViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: SolarListViewModel.Input(
            didSelect: mainView.collectionView.didSelect
        ))
        
        output.elements
            .drive(Binder(mainView.collectionView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(mainView.preloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
            })
            .disposed(by: disposeBag)
        
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
extension SolarListViewController {
    static func make() -> SolarListViewController {
        let vc = SolarListViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension SolarListViewController {
    func action(_ action: SolarListViewModel.Action) {
        switch action {
        case .open(let solarTemplate):
            let vc = SolarViewController.make(template: solarTemplate)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
