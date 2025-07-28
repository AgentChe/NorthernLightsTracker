//
//  RealWorldMapView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 28.07.2025.
//

import UIKit

final class RealWorldMapView: UIView {
    lazy var mapView = makeMapView()
    lazy var myGeoButton = makeMyGeoButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension RealWorldMapView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension RealWorldMapView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            myGeoButton.widthAnchor.constraint(equalToConstant: 54.scale),
            myGeoButton.heightAnchor.constraint(equalToConstant: 54.scale),
            myGeoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            myGeoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension RealWorldMapView {
    func makeMapView() -> RWMMapView {
        let view = RWMMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeMyGeoButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "RealWorldMap.MyGeo"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
