//
//  ForecastPlanetaryACell.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 21.07.2025.
//

import UIKit

final class ForecastPlanetaryACell: UITableViewCell {
    var didTap: (() -> Void)?
    
    lazy var titleView = makeTitleView()
    lazy var apLabel = makeLabel()
    lazy var descriptionLabel = makeLabel()
    lazy var separator = makeSeparator()
    
    private lazy var apAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.IBMPlexSans.bold(size: 22.scale))
        .lineHeight(29.scale)
        .textAlignment(.left)
    private lazy var activityAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.IBMPlexSans.bold(size: 16.scale))
        .lineHeight(25.scale)
        .textAlignment(.left)
    private lazy var descriptionAttrs = TextAttributes()
        .textColor(Appearance.mono100.withAlphaComponent(0.5))
        .font(Fonts.IBMPlexSans.regular(size: 16.scale))
        .lineHeight(24.scale)
        .textAlignment(.left)
    
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
extension ForecastPlanetaryACell {
    func setup(element: ForecastPlanetaryA) {
        let ap = NSMutableAttributedString()
        ap.append(String(format: "Forecast.PlanetaryA.AP".localized, element.ap).attributed(with: apAttrs))
        ap.append(element.activity.attributed(with: activityAttrs))
        apLabel.attributedText = ap
        
        descriptionLabel.attributedText = element.advice.attributed(with: descriptionAttrs)
    }
}

// MARK: Private
private extension ForecastPlanetaryACell {
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
private extension ForecastPlanetaryACell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            apLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            apLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            apLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            descriptionLabel.topAnchor.constraint(equalTo: apLabel.bottomAnchor, constant: 6.scale),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.scale)
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
private extension ForecastPlanetaryACell {
    func makeTitleView() -> ForecastExpandableTitleView {
        let view = ForecastExpandableTitleView()
        view.setup(opened: true)
        view.setup(iconName: "Forecast.PlanetaryA", text: "Forecast.PlanetaryA.Title".localized)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
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
