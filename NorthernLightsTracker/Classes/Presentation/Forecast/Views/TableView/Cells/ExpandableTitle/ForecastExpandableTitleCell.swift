//
//  ForecastExpandableTitleCell.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 21.07.2025.
//

import UIKit

final class ForecastExpandableTitleCell: UITableViewCell {
    enum Element {
        case kp
        case cloudCover
        case moonPhase
        case solarWind
        case hemisphericPower
        case planetaryA
    }
    
    var didTap: (() -> Void)?
    
    lazy var titleView = makeTitleView()
    lazy var separator = makeSeparator()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ForecastExpandableTitleCell {
    func setup(element: Element) {
        titleView.setup(
            iconName: element.iconName,
            text: element.title
        )
    }
}

// MARK: Private
private extension ForecastExpandableTitleCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
        
        titleView.didTap = { [weak self] in
            self?.didTap?()
        }
    }
}

// MARK: Make constraints
private extension ForecastExpandableTitleCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            titleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            separator.heightAnchor.constraint(equalToConstant: 1.scale),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ForecastExpandableTitleCell {
    func makeTitleView() -> ForecastExpandableTitleView {
        let view = ForecastExpandableTitleView()
        view.setup(opened: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main300
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

// MARK: Additional
private extension ForecastExpandableTitleCell.Element {
    var iconName: String {
        switch self {
        case .kp:
            return "Forecast.KP"
        case .cloudCover:
            return "Forecast.CloudCover"
        case .moonPhase:
            return "Forecast.MoonPhase"
        case .solarWind:
            return "Forecast.SolarWind"
        case .hemisphericPower:
            return "Forecast.HemisphericPower"
        case .planetaryA:
            return "Forecast.PlanetaryA"
        }
    }
    
    var title: String {
        switch self {
        case .kp:
            return "Forecast.KP.Title".localized
        case .cloudCover:
            return "Forecast.CloudCover.Title".localized
        case .moonPhase:
            return "Forecast.MoonPhase.Title".localized
        case .solarWind:
            return "Forecast.SolarWind.Title".localized
        case .hemisphericPower:
            return "Forecast.HemisphericPower.Title".localized
        case .planetaryA:
            return "Forecast.PlanetaryA.Title".localized
        }
    }
}
