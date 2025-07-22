//
//  SettingsAlertsButton.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 22.07.2025.
//

import UIKit

final class SettingsAlertsButton: UIButton {
    enum Field {
        case kp
        case cloudBreak
    }
    
    lazy var label = makeLabel()
    lazy var switchView = makeSwitchView()
    lazy var separator = makeSeparator()
    
    let field: Field
    
    init(field: Field) {
        self.field = field
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension SettingsAlertsButton {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension SettingsAlertsButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -75.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 19.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -19.scale)
        ])
        
        NSLayoutConstraint.activate([
            switchView.widthAnchor.constraint(equalToConstant: 51.scale),
            switchView.heightAnchor.constraint(equalToConstant: 31.scale),
            switchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            switchView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsAlertsButton {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.IBMPlexSans.regular(size: 16.scale))
            .lineHeight(24.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = field.title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSwitchView() -> UISwitch {
        let view = UISwitch()
        view.isUserInteractionEnabled = false
        view.onTintColor = Appearance.main200
        view.tintColor = Appearance.mono100.withAlphaComponent(0.2)
        view.thumbTintColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.isHidden = field.separatorHidden
        view.backgroundColor = Appearance.main300
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension SettingsAlertsButton.Field {
    var title: String {
        switch self {
        case .kp:
            return "SettingsAlerts.KP".localized
        case .cloudBreak:
            return "SettingsAlerts.CloudBreak".localized
        }
    }
    
    var separatorHidden: Bool {
        self == .cloudBreak
    }
}
