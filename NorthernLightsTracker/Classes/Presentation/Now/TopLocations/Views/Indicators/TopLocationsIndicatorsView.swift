//
//  TopLocationsIndicatorsView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 24.07.2025.
//

import UIKit

final class TopLocationsIndicatorsView: UIView {
    lazy var kpFieldView = makeKPFieldView()
    lazy var cloudCoverFieldView = makeCloudCoverFieldView()
    lazy var peakTimeFieldView = makePeakTimeFieldView()
    
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
extension TopLocationsIndicatorsView {
    func setup(location: AuroraTopLocation) {
        kpFieldView.setup(kp: location.kpIndex)
        cloudCoverFieldView.setup(cloudCover: location.cloudCover)
        peakTimeFieldView.setup(peakTime: location.peakTime)
    }
}

// MARK: Private
private extension TopLocationsIndicatorsView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension TopLocationsIndicatorsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            kpFieldView.leadingAnchor.constraint(equalTo: leadingAnchor),
            kpFieldView.trailingAnchor.constraint(equalTo: trailingAnchor),
            kpFieldView.topAnchor.constraint(equalTo: topAnchor),
            kpFieldView.heightAnchor.constraint(equalToConstant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            cloudCoverFieldView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cloudCoverFieldView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cloudCoverFieldView.topAnchor.constraint(equalTo: kpFieldView.bottomAnchor, constant: 11.scale),
            cloudCoverFieldView.heightAnchor.constraint(equalToConstant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            peakTimeFieldView.leadingAnchor.constraint(equalTo: leadingAnchor),
            peakTimeFieldView.trailingAnchor.constraint(equalTo: trailingAnchor),
            peakTimeFieldView.topAnchor.constraint(equalTo: cloudCoverFieldView.bottomAnchor, constant: 11.scale),
            peakTimeFieldView.bottomAnchor.constraint(equalTo: bottomAnchor),
            peakTimeFieldView.heightAnchor.constraint(equalToConstant: 24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TopLocationsIndicatorsView {
    func makeKPFieldView() -> TopLocationsIndicatorFieldView {
        let view = TopLocationsIndicatorFieldView(title: "TopLocations.Indicators.KP".localized)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloudCoverFieldView() -> TopLocationsIndicatorFieldView {
        let view = TopLocationsIndicatorFieldView(title: "TopLocations.Indicators.CloudCover".localized)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePeakTimeFieldView() -> TopLocationsIndicatorFieldView {
        let view = TopLocationsIndicatorFieldView(title: "TopLocations.Indicators.PeakTime".localized)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
