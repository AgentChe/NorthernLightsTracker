//
//  OnboardingView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class OnboardingView: UIView {
    enum Slide: Hashable {}
    
    private lazy var slidesViews: [Slide: UIView] = [:]
    
    private let finish: () -> Void
    
    init(finish: @escaping () -> Void) {
        self.finish = finish
        
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OnboardingView {
    func initialize() {
        backgroundColor = Appearance.main300
        
//        if let view = slidesViews[.instruction1] {
//            view.frame.origin = CGPoint.zero
//            container.addSubview(view)
//        }
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
            currentView.removeFromSuperview()
        })
    }
}
