//
//  NowTableIndicatorsCell.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 23.07.2025.
//

import UIKit

final class NowTableIndicatorsCell: UITableViewCell {
    lazy var peakTimeView = makePeakTimeView()
    lazy var kpCloudCoverView = makeKPCloudCoverView()
    
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
extension NowTableIndicatorsCell {
    func setup(element: NowTableIndicatorsElement) {
        peakTimeView.setup(peakTime: element.peakTime)
        kpCloudCoverView.setup(kpIndex: element.kpIndex, cloudCover: element.cloudCover)
    }
}

// MARK: Private
private extension NowTableIndicatorsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension NowTableIndicatorsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            peakTimeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            peakTimeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 54.scale),
            peakTimeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            peakTimeView.heightAnchor.constraint(equalToConstant: 88.scale),
            peakTimeView.widthAnchor.constraint(equalToConstant: 163.scale)
        ])
        
        NSLayoutConstraint.activate([
            kpCloudCoverView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            kpCloudCoverView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 54.scale),
            kpCloudCoverView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            kpCloudCoverView.heightAnchor.constraint(equalToConstant: 88.scale),
            kpCloudCoverView.widthAnchor.constraint(equalToConstant: 163.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension NowTableIndicatorsCell {
    func makePeakTimeView() -> NowPeakTimeView {
        let view = NowPeakTimeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeKPCloudCoverView() -> NowKPCloudCoverView {
        let view = NowKPCloudCoverView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
