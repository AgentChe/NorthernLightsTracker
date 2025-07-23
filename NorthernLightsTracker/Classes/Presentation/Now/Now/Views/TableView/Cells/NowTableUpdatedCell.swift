//
//  NowTableUpdatedCell.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 23.07.2025.
//

import UIKit

final class NowTableUpdatedCell: UITableViewCell {
    lazy var label = makeLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono100.withAlphaComponent(0.8))
        .font(Fonts.IBMPlexSans.regular(size: 14.scale))
        .lineHeight(18.scale)
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
extension NowTableUpdatedCell {
    func setup(element: TimeInterval) {
        let date = Date(timeIntervalSince1970: element)
        let calendar = Calendar.current
        let now = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        if calendar.isDate(date, inSameDayAs: now) {
            dateFormatter.dateFormat = "HH:mm"
        } else if calendar.component(.year, from: date) == calendar.component(.year, from: now) {
            dateFormatter.dateFormat = "dd MMM HH:mm"
        } else {
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        }
        
        let localizedUpdate = dateFormatter.string(from: date)
        label.attributedText = String(format: "Now.Updated".localized, localizedUpdate).attributed(with: attrs)
    }
}

// MARK: Private
private extension NowTableUpdatedCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension NowTableUpdatedCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension NowTableUpdatedCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
