//
//  NowTableCurrentLocationCell.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 23.07.2025.
//

import UIKit
import MapKit

final class NowTableCurrentLocationCell: UITableViewCell {
    lazy var mapView = makeMapView()
    
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
extension NowTableCurrentLocationCell {
    func setup(element: Location) {
        let coordinate = CLLocationCoordinate2D(latitude: element.coordinate.lat, longitude: element.coordinate.lon)

        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 3000000,
            longitudinalMeters: 3000000
        )
        mapView.setRegion(region, animated: false)
        
        mapView.removeAnnotations(mapView.annotations)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
}

// MARK: Private
private extension NowTableCurrentLocationCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension NowTableCurrentLocationCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 126.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension NowTableCurrentLocationCell {
    func makeMapView() -> MKMapView {
        let view = MKMapView()
        view.overrideUserInterfaceStyle = .dark
        view.mapType = .mutedStandard
        view.isUserInteractionEnabled = false
        view.isScrollEnabled = false
        view.isZoomEnabled = false
        view.showsUserLocation = false
        view.layer.cornerRadius = 16.scale
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
