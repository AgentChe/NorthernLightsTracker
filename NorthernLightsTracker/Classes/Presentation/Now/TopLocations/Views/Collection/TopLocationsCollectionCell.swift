//
//  TopLocationsCollectionCell.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 24.07.2025.
//

import UIKit

final class TopLocationsCollectionCell: UICollectionViewCell {
    enum Constants {
        static let green = "🟢"
        static let yellow = "🟡"
        static let red = "🔴"
    }
    
    private lazy var nameLabel = makeLabel()
    private lazy var statusLabel = makeLabel()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.IBMPlexSans.bold(size: 16.scale))
        .lineHeight(24.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    private lazy var statusAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.IBMPlexSans.regular(size: 16.scale))
        .lineHeight(24.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    
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
extension TopLocationsCollectionCell {
    func setup(element: TopLocationsCollectionElement) {
        contentView.backgroundColor = element.selected ? Appearance.main300 : Appearance.main400
        
        nameLabel.attributedText = element.location.name.attributed(with: nameAttrs)
        
        let status: String? = {
            let statusIndicator: String? = {
                guard let kp = element.location.kpIndex else { return nil }
                
                if (kp >= 0) && (kp <= 3) {
                    return Constants.red
                } else if (kp >= 4) && (kp <= 5) {
                    return Constants.yellow
                } else if (kp >= 6) && (kp <= 9) {
                    return Constants.green
                }
                
                return nil
            }()
            
            guard let statusIndicator, let statusText = element.location.status else { return nil }
            
            return String(format: "%@ %@", statusIndicator, statusText)
        }()
        statusLabel.attributedText = status?.attributed(with: statusAttrs)
    }
}

// MARK: Private
private extension TopLocationsCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        
        contentView.layer.cornerRadius = 12.scale
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = Appearance.main300.cgColor
        contentView.layer.borderWidth = 1.scale
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension TopLocationsCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TopLocationsCollectionCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
