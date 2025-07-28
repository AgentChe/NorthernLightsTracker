//
//  RWMMapView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 28.07.2025.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

final class RWMMapView: UIView {
    lazy var mapView = makeMapView()
    
    private lazy var didTapCoordinateTrigger = PublishRelay<Coordinate>()
    
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
extension RWMMapView {
    func setup(annotation: TopLocationAnnotation?) {
        mapView.removeAnnotations(mapView.annotations)
        
        guard let annotation else { return }
        
        mapView.addAnnotation(annotation)
    }
    
    func moveToMyGeo() {
        guard let location = mapView.userLocation.location?.coordinate else { return }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    var didTapCoordinate: Signal<Coordinate> {
        didTapCoordinateTrigger.asSignal()
    }
}

// MARK: MKMapViewDelegate
extension RWMMapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let ann = annotation as? TopLocationAnnotation else { return nil }

        let id = "RealWorldMap Annotation"
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

// MARK: UIGestureRecognizerDelegate
extension RWMMapView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

// MARK: Private
private extension RWMMapView {
    func initialize() {
        backgroundColor = UIColor.clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        tapGesture.delegate = self
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleMapTap(_ recognizer: UITapGestureRecognizer) {
        let pointInView = recognizer.location(in: mapView)
        
        let tappedCoordinate = mapView.convert(pointInView, toCoordinateFrom: mapView)
        let coordinate = Coordinate(lat: tappedCoordinate.latitude, lon: tappedCoordinate.longitude)
        
        didTapCoordinateTrigger.accept(coordinate)
    }
}

// MARK: Make constraints
private extension RWMMapView {
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
private extension RWMMapView {
    func makeMapView() -> MKMapView {
        let view = MKMapView()
        view.overrideUserInterfaceStyle = .dark
        view.mapType = .mutedStandard
        view.showsUserLocation = true
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
