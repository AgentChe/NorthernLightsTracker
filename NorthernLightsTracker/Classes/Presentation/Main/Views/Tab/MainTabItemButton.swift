//
//  MainTabItemButton.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 18.07.2025.
//

import UIKit

final class MainTabItemButton: UIButton {
    enum Tab {
        case now, map, forecast, solar
    }
    
    enum Mode {
        case selected, deselected
    }
    
    lazy var iconView = makeImageView()
    lazy var label = makeLabel()
    
    var mode = Mode.deselected {
        didSet {
            update()
        }
    }
    
    let tab: Tab
    
    init(tab: Tab) {
        self.tab = tab
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension MainTabItemButton {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func update() {
        iconView.alpha = mode == .selected ? 1 : 0.6
        label.alpha = mode == .selected ? 1 : 0.6
    }
}

// MARK: Make constraints
private extension MainTabItemButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 6.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MainTabItemButton {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: tab.iconName)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.IBMPlexSans.semiBold(size: 10.scale))
            .lineHeight(12.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = tab.title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension MainTabItemButton.Tab {
    var iconName: String {
        switch self {
        case .now:
            return "Main.Now"
        case .map:
            return "Main.Map"
        case .forecast:
            return "Main.Forecast"
        case .solar:
            return "Main.Solar"
        }
    }
    
    var title: String {
        switch self {
        case .now:
            return "Main.Now".localized
        case .map:
            return "Main.Map".localized
        case .forecast:
            return "Main.Forecast".localized
        case .solar:
            return "Main.Solar".localized
        }
    }
}
