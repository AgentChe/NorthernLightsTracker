//
//  ForecastMoonPhaseCell.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 21.07.2025.
//

import UIKit

final class ForecastMoonPhaseCell: UITableViewCell {
    var didTap: (() -> Void)?
    
    lazy var titleView = makeTitleView()
    lazy var adviceLabel = makeAdviceLabel()
    lazy var illuminationLabel = makeLabel()
    lazy var descriptionLabel = makeLabel()
    lazy var separator = makeSeparator()
    
    private lazy var adviceAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.IBMPlexSans.regular(size: 16.scale))
        .lineHeight(24.scale)
        .textAlignment(.left)
    private lazy var illuminationValueAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.IBMPlexSans.bold(size: 22.scale))
        .lineHeight(29.scale)
        .textAlignment(.left)
    private lazy var illuminationTextAttrs = TextAttributes()
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
extension ForecastMoonPhaseCell {
    func setup(element: ForecastMoonPhase) {
        adviceLabel.attributedText = element.advice.attributed(with: adviceAttrs)
        
        let illumination = NSMutableAttributedString()
        illumination.append(String(format: "%i%%", element.illumination).attributed(with: illuminationValueAttrs))
        illumination.append((" " + element.phase).attributed(with: illuminationTextAttrs))
        illuminationLabel.attributedText = illumination
        
        descriptionLabel.attributedText = element.description.attributed(with: descriptionAttrs)
    }
}

// MARK: Private
private extension ForecastMoonPhaseCell {
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
private extension ForecastMoonPhaseCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            adviceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            adviceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            adviceLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            illuminationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            illuminationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            illuminationLabel.topAnchor.constraint(equalTo: adviceLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            descriptionLabel.topAnchor.constraint(equalTo: illuminationLabel.bottomAnchor, constant: 6.scale),
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
private extension ForecastMoonPhaseCell {
    func makeTitleView() -> ForecastExpandableTitleView {
        let view = ForecastExpandableTitleView()
        view.setup(opened: true)
        view.setup(iconName: "Forecast.MoonPhase", text: "Forecast.MoonPhase.Title".localized)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeAdviceLabel() -> PaddingLabel {
        let view = PaddingLabel()
        view.numberOfLines = 0
        view.insets = UIEdgeInsets(value: 16.scale)
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 12.scale
        view.layer.masksToBounds = true
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
