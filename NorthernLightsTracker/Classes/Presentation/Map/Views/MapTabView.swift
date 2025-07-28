//
//  MapTabView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 28.07.2025.
//

import UIKit

final class MapTabView: UIView {
    enum Tab {
        case realWorldMap
        case auroraOvalLayer
    }
    
    lazy var selector = makeSelector()
    lazy var realWorldMapButton = makeButton(title: "Map.Tab.RealWorldMap".localized)
    lazy var auroraOvalLayerButton = makeButton(title: "Map.Tab.AuroraOvalLayer".localized)
    
    private lazy var selectorLeadingConstraint = NSLayoutConstraint()
    private lazy var selectorTrailingConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MapTabView {
    func setup(tab: Tab, animate: Bool) {
        NSLayoutConstraint.deactivate([
            selectorLeadingConstraint,
            selectorTrailingConstraint
        ])
        
        switch tab {
        case .realWorldMap:
            selectorLeadingConstraint = selector.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.scale)
            selectorTrailingConstraint = selector.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -6.scale)
        case .auroraOvalLayer:
            selectorLeadingConstraint = selector.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 6.scale)
            selectorTrailingConstraint = selector.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.scale)
        }
        
        NSLayoutConstraint.activate([
            selectorLeadingConstraint,
            selectorTrailingConstraint
        ])
        
        if animate {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.layoutIfNeeded()
            })
        } else {
            layoutIfNeeded()
        }
    }
}

// MARK: Private
private extension MapTabView {
    func initialize() {
        backgroundColor = Appearance.main400
        layer.cornerRadius = 12.scale
    }
}

// MARK: Make constraints
private extension MapTabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            selector.topAnchor.constraint(equalTo: topAnchor, constant: 10.scale),
            selector.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            realWorldMapButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.scale),
            realWorldMapButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -6.scale),
            realWorldMapButton.topAnchor.constraint(equalTo: topAnchor, constant: 10.scale),
            realWorldMapButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            auroraOvalLayerButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 6.scale),
            auroraOvalLayerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.scale),
            auroraOvalLayerButton.topAnchor.constraint(equalTo: topAnchor, constant: 10.scale),
            auroraOvalLayerButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MapTabView {
    func makeSelector() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 12.scale
        view.backgroundColor = Appearance.mono100.withAlphaComponent(0.06)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton(title: String) -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.IBMPlexSans.regular(size: 14.scale))
        
        let view = UIButton()
        view.setAttributedTitle(title.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
