//
//  SolarTableImageCell.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 19.07.2025.
//

import UIKit

final class SolarTableImageCell: UITableViewCell {
    lazy var pictureView = makeImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pictureView.kf.cancelDownloadTask()
        pictureView.image = nil
    }
}

// MARK: Public
extension SolarTableImageCell {
    func setup(element: URL) {
        pictureView.kf.setImage(with: element)
    }
}

// MARK: Private
private extension SolarTableImageCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SolarTableImageCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            pictureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            pictureView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            pictureView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            pictureView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            pictureView.heightAnchor.constraint(equalToConstant: 360.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SolarTableImageCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 12.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
