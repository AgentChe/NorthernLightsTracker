//
//  MapViewController.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 28.07.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class MapViewController: UIViewController {
    private lazy var mainView = MapView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var coordinator = MapCoordinator(
        parentVC: self,
        container: mainView.container
    )
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Signal
            .merge([
                mainView.tabView.realWorldMapButton
                    .rx.tap.map { MapTabView.Tab.realWorldMap }
                    .asSignal(onErrorSignalWith: .never()),
                
                mainView.tabView.auroraOvalLayerButton
                    .rx.tap.map { MapTabView.Tab.auroraOvalLayer }
                    .asSignal(onErrorSignalWith: .never())
            ])
            .emit(to: Binder(self) { base, tab in
                base.update(selectedTab: tab, animate: true)
            })
            .disposed(by: disposeBag)
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .bind(to: Binder(self) { base, void in
                base.update(selectedTab: .realWorldMap, animate: false)
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

// MARK: PUblic
extension MapViewController {
    static func make() -> MapViewController {
        let vc = MapViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension MapViewController {
    func update(selectedTab: MapTabView.Tab, animate: Bool) {
        mainView.tabView.setup(tab: selectedTab, animate: animate)
        
        coordinator.change(tab: selectedTab)
    }
}
