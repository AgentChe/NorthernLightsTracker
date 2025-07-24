//
//  TopLocationsIndicatorFieldView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 24.07.2025.
//

import UIKit

final class TopLocationsIndicatorFieldView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var valueLabel = makeValueLabel()
    
    private lazy var valueAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.IBMPlexSans.bold(size: 16.scale))
        .lineHeight(24.scale)
        .textAlignment(.right)
    
    private let title: String
    
    init(title: String) {
        self.title = title
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TopLocationsIndicatorFieldView {
    func setup(kp: Double?) {
        let value: String = {
            guard let kp else { return "-" }
            return String(kp)
        }()
        valueLabel.attributedText = value.attributed(with: valueAttrs)
    }
    
    func setup(cloudCover: Int?) {
        let value: String = {
            guard let cloudCover else { return "-" }
            return String(format: "%i%%", cloudCover)
        }()
        valueLabel.attributedText = value.attributed(with: valueAttrs)
    }
    
    func setup(peakTime: PeakTime?) {
        let calendar = Calendar.current
        let now = Date()
        
        let value: String = {
            guard let peakTime else { return "-" }
            
            let fromDate = Date(timeIntervalSince1970: peakTime.from)
            let toDate = Date(timeIntervalSince1970: peakTime.to)
            
            let sameDay = calendar.isDate(fromDate, inSameDayAs: now)

            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            
            formatter.dateFormat = sameDay ? "HH:mm" : "dd MMM HH:mm"

            let fromString = formatter.string(from: fromDate)
            let toString = formatter.string(from: toDate)
            
            return "\(fromString) – \(toString)"
        }()
        
        valueLabel.attributedText = value.attributed(with: valueAttrs)
    }
}

// MARK: Private
private extension TopLocationsIndicatorFieldView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension TopLocationsIndicatorFieldView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TopLocationsIndicatorFieldView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100.withAlphaComponent(0.8))
            .font(Fonts.IBMPlexSans.regular(size: 14.scale))
            .lineHeight(18.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
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
