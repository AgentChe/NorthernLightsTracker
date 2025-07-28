//
//  RealWorldMapViewController.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 28.07.2025.
//

import UIKit
import RxSwift
import CoreLocation

final class RealWorldMapViewController: UIViewController {
    private lazy var mainView = RealWorldMapView()
    
    private lazy var viewModel = RealWorldMapViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.mapView.mapView.rx
            .observe(CLLocation.self, "userLocation.location")
            .map { $0 == nil }
            .distinctUntilChanged()
            .bind(to: mainView.myGeoButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        let output = viewModel.configure(input: RealWorldMapViewModel.Input(
            didTapMyGeo: mainView.myGeoButton.rx.tap.asSignal(),
            didTapCoordinate: mainView.mapView.didTapCoordinate
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.annotation
            .drive(Binder(mainView.mapView) { base, annotation in
                base.setup(annotation: annotation)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension RealWorldMapViewController {
    static func make() -> RealWorldMapViewController {
        let vc = RealWorldMapViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
extension RealWorldMapViewController {
    func action(_ action: RealWorldMapViewModel.Action) {
        switch action {
        case .moveToMyGeo:
            mainView.mapView.moveToMyGeo()
        }
    }
}
