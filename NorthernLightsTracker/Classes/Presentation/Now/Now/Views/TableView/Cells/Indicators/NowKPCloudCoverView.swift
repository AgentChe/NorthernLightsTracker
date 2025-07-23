//
//  NowKPCloudCoverView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 23.07.2025.
//

import UIKit

final class NowKPCloudCoverView: UIView {
    lazy var kpTitleLabel = makeKPTitleLabel()
    lazy var kpValueLabel = makeValueLabel()
    lazy var cloudCoverTitleLabel = makeCloudCoverTitleLabel()
    lazy var cloudCoverValueLabel = makeValueLabel()
    
    private lazy var valueAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.IBMPlexSans.bold(size: 16.scale))
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
extension NowKPCloudCoverView {
    func setup(kpIndex: Double?, cloudCover: Int?) {
        let kp: String = {
            guard let kpIndex else { return "-" }
            return String(kpIndex)
        }()
        kpValueLabel.attributedText = kp.attributed(with: valueAttrs)
        
        let cloudCover: String = {
            guard let cloudCover else { return "-" }
            return String(format: "%i%%", cloudCover)
        }()
        cloudCoverValueLabel.attributedText = cloudCover.attributed(with: valueAttrs)
    }
}

// MARK: Private
private extension NowKPCloudCoverView {
    func initialize() {
        backgroundColor = Appearance.main300
        layer.cornerRadius = 12.scale
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.main300.cgColor
    }
}

// MARK: Make constraints
private extension NowKPCloudCoverView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            kpTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            kpTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 17.scale)
        ])
        
        NSLayoutConstraint.activate([
            kpValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            kpValueLabel.centerYAnchor.constraint(equalTo: kpTitleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cloudCoverTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            cloudCoverTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17.scale)
        ])
        
        NSLayoutConstraint.activate([
            cloudCoverValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cloudCoverValueLabel.centerYAnchor.constraint(equalTo: cloudCoverTitleLabel.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension NowKPCloudCoverView {
    func makeKPTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100.withAlphaComponent(0.8))
            .font(Fonts.IBMPlexSans.regular(size: 14.scale))
            .lineHeight(18.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Now.KP".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloudCoverTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100.withAlphaComponent(0.8))
            .font(Fonts.IBMPlexSans.regular(size: 14.scale))
            .lineHeight(18.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Now.CloudCover".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeValueLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
