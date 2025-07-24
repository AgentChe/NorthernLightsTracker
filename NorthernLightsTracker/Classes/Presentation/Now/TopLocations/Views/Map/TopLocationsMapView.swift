//
//  TopLocationsMapView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 24.07.2025.
//

import UIKit
import MapKit

final class TopLocationsMapView: UIView {
    lazy var mapView = makeMapView()
    
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
extension TopLocationsMapView {
    func setup(location: AuroraTopLocation) {
        mapView.removeAnnotations(mapView.annotations)

        let coord = CLLocationCoordinate2D(
            latitude: location.coordinate.lat,
            longitude: location.coordinate.lon
        )
        let region = MKCoordinateRegion(
            center: coord,
            latitudinalMeters: 3000000,
            longitudinalMeters: 3000000
        )
        mapView.setRegion(region, animated: false)
        
        let annotation = TopLocationAnnotation(location: location)
        mapView.addAnnotation(annotation)
    }
}

// MARK: MKMapViewDelegate
extension TopLocationsMapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let ann = annotation as? TopLocationAnnotation else { return nil }

        let id = "TopLocationMarker"
        let av = mapView.dequeueReusableAnnotationView(withIdentifier: id)
            ?? MKAnnotationView(annotation: ann, reuseIdentifier: id)
        av.annotation = ann

        let callout = CalloutWithArrowView(title: ann.title, subtitle: ann.subtitle)
        let calloutSize = callout.sizeThatFits(
            CGSize(width: 165.scale, height: .greatestFiniteMagnitude)
        )
        callout.frame = CGRect(origin: .zero, size: calloutSize)

        let renderer = UIGraphicsImageRenderer(size: calloutSize)
        let img = renderer.image { ctx in
            callout.layer.render(in: ctx.cgContext)
        }
        av.image = img

        av.centerOffset = CGPoint(
            x: 0,
            y: -calloutSize.height / 2
        )

        return av
    }
}

// MARK: Private
private extension TopLocationsMapView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension TopLocationsMapView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TopLocationsMapView {
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
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
