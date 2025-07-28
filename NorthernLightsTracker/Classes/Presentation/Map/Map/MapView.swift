//
//  MapView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 28.07.2025.
//

import UIKit

final class MapView: UIView {
    lazy var tabView = makeTabView()
    lazy var container = makeContainer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstriants()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension MapView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension MapView {
    func makeConstriants() {
        NSLayoutConstraint.activate([
            tabView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            tabView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            tabView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8.scale),
            tabView.heightAnchor.constraint(equalToConstant: 54.scale)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: tabView.bottomAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension MapView {
    func makeTabView() -> MapTabView {
        let view = MapTabView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono200
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
