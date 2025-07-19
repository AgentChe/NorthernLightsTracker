//
//  MainCoordinator.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 18.07.2025.
//

import UIKit

final class MainViewCoordinator {
    lazy var nowVC = UIViewController()
    lazy var mapVC = UIViewController()
    lazy var forecastVC = UIViewController()
    lazy var solarVC = SolarListViewController.make()
    
    private weak var parentVC: UIViewController?
    private weak var container: UIView?
    
    private var previousVC: UIViewController?
    
    init(parentVC: UIViewController, container: UIView) {
        self.parentVC = parentVC
        self.container = container
    }
    
    func change(tab: MainTabItemButton.Tab) {
        switch tab {
        case .now:
            changeVC(on: nowVC)
        case .map:
            changeVC(on: mapVC)
        case .forecast:
            changeVC(on: forecastVC)
        case .solar:
            changeVC(on: solarVC)
        }
    }
}

// MARK: Private
private extension MainViewCoordinator {
    func changeVC(on vc: UIViewController) {
        if let previousVC = self.previousVC {
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
        }
    
        self.previousVC = vc
        
        guard let parentVC, let container else {
            return
        }
    
        parentVC.addChild(vc)
        vc.view.frame = container.bounds
        container.addSubview(vc.view)
        vc.willMove(toParent: parentVC)
    }
}
