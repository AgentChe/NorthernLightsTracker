//
//  SettingsView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 22.07.2025.
//

import UIKit

final class SettingsView: UIView {
    lazy var auroraAlertsButton = makeButton(action: .auroraAlerts)
    lazy var locationButton = makeButton(action: .location)
    lazy var termsOfUseButton = makeButton(action: .termsOfUse)
    lazy var privacyPoliceButton = makeButton(action: .privacyPolice)
    lazy var supportButton = makeButton(action: .support)
    
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
private extension SettingsView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension SettingsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            auroraAlertsButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            auroraAlertsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            auroraAlertsButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 6.scale)
        ])
        
        NSLayoutConstraint.activate([
            locationButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            locationButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            locationButton.topAnchor.constraint(equalTo: auroraAlertsButton.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            termsOfUseButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            termsOfUseButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            termsOfUseButton.topAnchor.constraint(equalTo: locationButton.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            privacyPoliceButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            privacyPoliceButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            privacyPoliceButton.topAnchor.constraint(equalTo: termsOfUseButton.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            supportButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            supportButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            supportButton.topAnchor.constraint(equalTo: privacyPoliceButton.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsView {
    func makeButton(action: SettingsButton.Action) -> SettingsButton {
        let view = SettingsButton(action: action)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
