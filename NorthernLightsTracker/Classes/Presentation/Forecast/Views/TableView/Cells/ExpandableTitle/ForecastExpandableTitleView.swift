//
//  ForecastExpandableTitleView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 21.07.2025.
//

import UIKit

final class ForecastExpandableTitleView: UIView {
    var didTap: (() -> Void)?
    
    lazy var iconView = makeImageView()
    lazy var label = makeLabel()
    lazy var arrowView = makeImageView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.IBMPlexSans.regular(size: 16.scale))
        .lineHeight(24.scale)
        .textAlignment(.left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ForecastExpandableTitleView {
    func setup(iconName: String, text: String) {
        iconView.image = UIImage(named: iconName)
        
        label.attributedText = text.attributed(with: attrs)
    }
    
    func setup(opened: Bool) {
        let iconName = opened ? "Forecast.Arrow.Up" : "Forecast.Arrow.Down"
        arrowView.image = UIImage(named: iconName)
    }
}

// MARK: Private
private extension ForecastExpandableTitleView {
    func initialize() {
        backgroundColor = UIColor.clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
    }
    
    @objc
    func tapped() {
        didTap?()
    }
}

// MARK: Make constraints
private extension ForecastExpandableTitleView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.widthAnchor.constraint(equalToConstant: 24.scale),
            arrowView.heightAnchor.constraint(equalToConstant: 24.scale),
            arrowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            arrowView.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ForecastExpandableTitleView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
