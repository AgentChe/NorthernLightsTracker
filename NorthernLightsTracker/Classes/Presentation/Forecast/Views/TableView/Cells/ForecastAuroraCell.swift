//
//  ForecastAuroraCell.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 20.07.2025.
//

import UIKit

final class ForecastAuroraCell: UITableViewCell {
    lazy var iconView = makeIconView()
    lazy var titleLabel = makeTitleLabel()
    lazy var probabilityLabel = makeLabel()
    lazy var bestViewTimeLabel = makeLabel()
    lazy var separator = makeSeparator()
    
    private lazy var probabilityValueAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.IBMPlexSans.bold(size: 22.scale))
        .lineHeight(29.scale)
        .textAlignment(.left)
    private lazy var probabilityTextAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.IBMPlexSans.bold(size: 16.scale))
        .lineHeight(25.scale)
        .textAlignment(.left)
    private lazy var bestViewTimeAttrs = TextAttributes()
        .textColor(Appearance.mono100.withAlphaComponent(0.5))
        .font(Fonts.IBMPlexSans.regular(size: 16.scale))
        .lineHeight(24.scale)
        .textAlignment(.left)
    
    private lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale.current
        return formatter
    }()
    
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
extension ForecastAuroraCell {
    func setup(element: ForecastAurora) {
        let probability = NSMutableAttributedString()
        probability.append(String(format: "%i%%", element.probability).attributed(with: probabilityValueAttrs))
        probability.append("Forecast.Aurora.Probability".localized.attributed(with: probabilityTextAttrs))
        probabilityLabel.attributedText = probability
        
        let fromViewTime = Date(timeIntervalSince1970: element.bestViewTime.from)
        let toViewTime = Date(timeIntervalSince1970: element.bestViewTime.to)
        
        let string = String(
            format: "Forecast.Aurora.BestViewTime".localized,
            timeFormatter.string(from: fromViewTime),
            timeFormatter.string(from: toViewTime)
        )
        bestViewTimeLabel.attributedText = string.attributed(with: bestViewTimeAttrs)
    }
}

// MARK: Private
private extension ForecastAuroraCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ForecastAuroraCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 48.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            probabilityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            probabilityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            probabilityLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            bestViewTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            bestViewTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            bestViewTimeLabel.topAnchor.constraint(equalTo: probabilityLabel.bottomAnchor, constant: 6.scale)
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
private extension ForecastAuroraCell {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Forecast.Aurora")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.IBMPlexSans.regular(size: 16.scale))
            .lineHeight(24.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Forecast.Aurora.Title".localized.attributed(with: attrs)
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
