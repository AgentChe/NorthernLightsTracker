//
//  SettingsAlertsView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 22.07.2025.
//

import UIKit

final class SettingsAlertsView: UIView {
    lazy var kpButton = makeButton(field: .kp)
    lazy var cloudBreakButton = makeButton(field: .cloudBreak)
    
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
private extension SettingsAlertsView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension SettingsAlertsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            kpButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            kpButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            kpButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 6.scale)
        ])
        
        NSLayoutConstraint.activate([
            cloudBreakButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            cloudBreakButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            cloudBreakButton.topAnchor.constraint(equalTo: kpButton.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsAlertsView {
    func makeButton(field: SettingsAlertsButton.Field) -> SettingsAlertsButton {
        let view = SettingsAlertsButton(field: field)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
