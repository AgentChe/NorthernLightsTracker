//
//  MainTabView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 18.07.2025.
//

import UIKit

final class MainTabView: UIView {
    lazy var nowItemButton = makeItemButton(tab: .now)
    lazy var mapItemButton = makeItemButton(tab: .map)
    lazy var forecastItemButton = makeItemButton(tab: .forecast)
    lazy var solarItemButton = makeItemButton(tab: .solar)
    
    var selectedTab = MainTabItemButton.Tab.now {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension MainTabView {
    func initialize() {
        backgroundColor = Appearance.main600
    }
    
    func update() {
        nowItemButton.mode = selectedTab == .now ? .selected : .deselected
        mapItemButton.mode = selectedTab == .map ? .selected : .deselected
        forecastItemButton.mode = selectedTab == .forecast ? .selected : .deselected
        solarItemButton.mode = selectedTab == .solar ? .selected : .deselected
    }
}

// MARK: Make constraints
private extension MainTabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            nowItemButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            nowItemButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            nowItemButton.topAnchor.constraint(equalTo: topAnchor),
            nowItemButton.widthAnchor.constraint(equalTo: mapItemButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mapItemButton.leadingAnchor.constraint(equalTo: nowItemButton.trailingAnchor),
            mapItemButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            mapItemButton.topAnchor.constraint(equalTo: topAnchor),
            mapItemButton.widthAnchor.constraint(equalTo: forecastItemButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            forecastItemButton.leadingAnchor.constraint(equalTo: mapItemButton.trailingAnchor),
            forecastItemButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            forecastItemButton.topAnchor.constraint(equalTo: topAnchor),
            forecastItemButton.widthAnchor.constraint(equalTo: solarItemButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            solarItemButton.leadingAnchor.constraint(equalTo: forecastItemButton.trailingAnchor),
            solarItemButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            solarItemButton.topAnchor.constraint(equalTo: topAnchor),
            solarItemButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension MainTabView {
    func makeItemButton(tab: MainTabItemButton.Tab) -> MainTabItemButton {
        let view = MainTabItemButton(tab: tab)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
