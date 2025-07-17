//
//  OnboardingView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class OnboardingView: UIView {
    enum Slide: Hashable {
        case aurora, kp, sun, alerts, location
    }
    
    private lazy var slidesViews: [Slide: OSlideView] = [
        .aurora: OAuroraView { [weak self] in
            self?.scroll(from: .aurora, to: .kp)
        },
        .kp: OKPView { [weak self] in
            self?.scroll(from: .kp, to: .sun)
        },
        .sun: OSunView { [weak self] in
            self?.scroll(from: .sun, to: .alerts)
        },
        .alerts: OAlertsView { [weak self] notificationsToken in
            self?.combineData.setup(notificationsToken: notificationsToken)
            self?.scroll(from: .alerts, to: .location)
        },
        .location: OLocationView { [weak self] geoId in
            self?.combineData.setup(geoId: geoId)
            
            guard let data = self?.combineData.make() else { return }
            
            self?.finish(data)
        }
    ]
    
    private lazy var combineData = OnboardingCombineData()
    
    private let finish: (OnboardingCombineData.CombineData) -> Void
    
    init(finish: @escaping (OnboardingCombineData.CombineData) -> Void) {
        self.finish = finish
        
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        slidesViews.map { $1 }.forEach { slideView in
            slideView.frame.size = bounds.size
        }
    }
}

// MARK: Private
private extension OnboardingView {
    func initialize() {
        backgroundColor = Appearance.mono200
        
        if let view = slidesViews[.aurora] {
            view.frame.origin = CGPoint.zero
            addSubview(view)
            
            view.moveToThis()
        }
    }
    
    func scroll(from: Slide, to: Slide) {
        guard let currentView = slidesViews[from], let scrollToView = slidesViews[to] else { return }
        
        scrollToView.frame.origin = CGPoint(x: bounds.size.width, y: 0)
        
        addSubview(scrollToView)
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self else { return }
            
            currentView.frame.origin = CGPoint(x: -bounds.size.width, y: 0)
            scrollToView.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { result in
            scrollToView.moveToThis()
            currentView.removeFromSuperview()
        })
    }
}
