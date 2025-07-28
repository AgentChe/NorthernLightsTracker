//
//  AuroraOvalLayerViewController.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 28.07.2025.
//

import UIKit
import RxSwift

final class AuroraOvalLayerViewController: UIViewController {
    private lazy var mainView = AuroraOvalLayerView()
    
    private lazy var viewModel = AuroraOvalLayerViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: AuroraOvalLayerViewModel.Input())
        
        output.activity
            .drive(Binder(mainView.preloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension AuroraOvalLayerViewController {
    static func make() -> AuroraOvalLayerViewController {
        let vc = AuroraOvalLayerViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}
