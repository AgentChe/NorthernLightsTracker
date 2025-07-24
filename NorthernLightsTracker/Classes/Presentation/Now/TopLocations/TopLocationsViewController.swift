//
//  TopLocationsViewController.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 23.07.2025.
//

import UIKit
import RxSwift

final class TopLocationsViewController: UIViewController {
    private lazy var mainView = TopLocationsView()
    
    private lazy var viewModel = TopLocationsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: TopLocationsViewModel.Input(
            didSelect: mainView.collectionView.didSelect
        ))
        
        output.elements
            .drive(Binder(mainView.collectionView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.selectedLocation
            .drive(Binder(mainView) { base, location in
                base.mapView.setup(location: location)
                base.indicatorsView.setup(location: location)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension TopLocationsViewController {
    static func make() -> TopLocationsViewController {
        let vc = TopLocationsViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "TopLocations.Title".localized
        return vc
    }
}
