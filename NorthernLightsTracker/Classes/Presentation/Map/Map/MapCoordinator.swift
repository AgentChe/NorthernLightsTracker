//
//  MapCoordinator.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 28.07.2025.
//

import UIKit

final class MapCoordinator {
    lazy var realWorldMapVC = RealWorldMapViewController.make()
    lazy var auroraOvalLayerVC = AuroraOvalLayerViewController.make()
    
    private weak var parentVC: UIViewController?
    private weak var container: UIView?
    
    private var previousVC: UIViewController?
    
    init(parentVC: UIViewController, container: UIView) {
        self.parentVC = parentVC
        self.container = container
    }
}

// MARK: Public
extension MapCoordinator {
    func change(tab: MapTabView.Tab) {
        switch tab {
        case .realWorldMap:
            changeVC(on: realWorldMapVC)
        case .auroraOvalLayer:
            changeVC(on: auroraOvalLayerVC)
        }
    }
}

// MARK: Private
private extension MapCoordinator {
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
