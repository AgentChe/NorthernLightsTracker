//
//  OnboardingView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class OnboardingView: UIView {
    enum Slide: Hashable {
        case instruction1
        case instruction2
    }
    
    private lazy var container = makeContainer()
    private lazy var pageIndicatorsView = makePageIndicatorsView()
    
    private lazy var slidesViews: [Slide: UIView] = [
        .instruction1: OnstructionView(slide: .first) { [weak self] in
            self?.scroll(from: .instruction1, to: .instruction2)
            self?.pageIndicatorsView.select(index: 1)
        },
        .instruction2: OnstructionView(slide: .second) { [weak self] in
            self?.finish()
        }
    ]
    
    private let finish: () -> Void
    
    init(finish: @escaping () -> Void) {
        self.finish = finish
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        pageIndicatorsView.select(index: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        slidesViews.map { $1 }.forEach { slideView in
            slideView.frame.size = container.bounds.size
        }
    }
}

// MARK: Private
private extension OnboardingView {
    func initialize() {
        backgroundColor = Appearance.main300
        
        if let view = slidesViews[.instruction1] {
            view.frame.origin = CGPoint.zero
            container.addSubview(view)
        }
    }
    
    func scroll(from: Slide, to: Slide) {
        guard let currentView = slidesViews[from], let scrollToView = slidesViews[to] else { return }
        
        scrollToView.frame.origin = CGPoint(x: bounds.size.width, y: 0)
        
        container.addSubview(scrollToView)
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self else { return }
            
            currentView.frame.origin = CGPoint(x: -bounds.size.width, y: 0)
            scrollToView.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { result in
            currentView.removeFromSuperview()
        })
    }
}

// MARK: Make constraints
private extension OnboardingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pageIndicatorsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageIndicatorsView.topAnchor.constraint(equalTo: topAnchor, constant: 64.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OnboardingView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePageIndicatorsView() -> OPageIndicatorView {
        let view = OPageIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
