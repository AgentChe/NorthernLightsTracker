//
//  ForecastKPCell.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 21.07.2025.
//

import UIKit
import DGCharts

final class ForecastKPCell: UITableViewCell {
    var didTap: (() -> Void)?
    
    lazy var titleView = makeTitleView()
    lazy var adviceLabel = makeAdviceLabel()
    lazy var levelLabel = makeLabel()
    lazy var descriptionLabel = makeLabel()
    lazy var chart = makeChart()
    lazy var separator = makeSeparator()
    
    private lazy var adviceAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.IBMPlexSans.regular(size: 16.scale))
        .lineHeight(24.scale)
        .textAlignment(.left)
    private lazy var levelValueAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.IBMPlexSans.bold(size: 22.scale))
        .lineHeight(29.scale)
        .textAlignment(.left)
    private lazy var levelTextAttrs = TextAttributes()
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
extension ForecastKPCell {
    func setup(element: ForecastKP) {
        adviceLabel.attributedText = element.advice.attributed(with: adviceAttrs)
        
        let level = NSMutableAttributedString()
        level.append(String(element.current).attributed(with: levelValueAttrs))
        level.append((" " + element.level).attributed(with: levelTextAttrs))
        levelLabel.attributedText = level
        
        descriptionLabel.attributedText = element.description.attributed(with: descriptionAttrs)
        
        chart.setup(forecast: element.forecast)
    }
}

// MARK: Private
private extension ForecastKPCell {
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
private extension ForecastKPCell {
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
            levelLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            levelLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            levelLabel.topAnchor.constraint(equalTo: adviceLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            descriptionLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 6.scale)
        ])
        
        NSLayoutConstraint.activate([
            chart.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            chart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            chart.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12.scale),
            chart.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.scale),
            chart.heightAnchor.constraint(equalToConstant: 176.scale)
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
private extension ForecastKPCell {
    func makeTitleView() -> ForecastExpandableTitleView {
        let view = ForecastExpandableTitleView()
        view.setup(opened: true)
        view.setup(iconName: "Forecast.KP", text: "Forecast.KP.Title".localized)
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
    
    func makeChart() -> ForecastKPChartView {
        let view = ForecastKPChartView()
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
