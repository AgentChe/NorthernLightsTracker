//
//  NowPeakTimeView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 23.07.2025.
//

import UIKit

final class NowPeakTimeView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var valueLabel = makeValueLabel()
    
    private lazy var hhMMAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.IBMPlexSans.bold(size: 16.scale))
        .lineHeight(24.scale)
        .textAlignment(.left)
    private lazy var ddMMMhhMMAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.IBMPlexSans.bold(size: 10.scale))
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
extension NowPeakTimeView {
    func setup(peakTime: PeakTime?) {
        let calendar = Calendar.current
        let now = Date()
        
        let string: String = {
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
        
        let attrs: TextAttributes = {
            guard let peakTime else { return hhMMAttrs }
            
            let fromDate = Date(timeIntervalSince1970: peakTime.from)
            
            let sameDay = calendar.isDate(fromDate, inSameDayAs: now)
            
            return sameDay ? hhMMAttrs : ddMMMhhMMAttrs
        }()
        
        valueLabel.attributedText = string.attributed(with: attrs)
    }
}

// MARK: Private
private extension NowPeakTimeView {
    func initialize() {
        backgroundColor = Appearance.main300
        layer.cornerRadius = 12.scale
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.main300.cgColor
    }
}

// MARK: Make constraints
private extension NowPeakTimeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14.5.scale)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14.5.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension NowPeakTimeView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100.withAlphaComponent(0.8))
            .font(Fonts.IBMPlexSans.regular(size: 14.scale))
            .lineHeight(18.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Now.PeakTime".localized.attributed(with: attrs)
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
