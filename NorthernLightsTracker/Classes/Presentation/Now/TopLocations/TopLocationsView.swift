//
//  TopLocationsView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 23.07.2025.
//

import UIKit

final class TopLocationsView: UIView {
    lazy var mapView = makeMapView()
    lazy var container = makeContainer()
    lazy var collectionView = makeCollectionView()
    lazy var indicatorsView = makeIndicatorsView()
    
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
private extension TopLocationsView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension TopLocationsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 270.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: container.topAnchor, constant: 34.scale),
            collectionView.heightAnchor.constraint(equalToConstant: 84.scale)
        ])
        
        NSLayoutConstraint.activate([
            indicatorsView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 30.scale),
            indicatorsView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -30.scale),
            indicatorsView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TopLocationsView {
    func makeMapView() -> TopLocationsMapView {
        let view = TopLocationsMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono200
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> TopLocationsCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 303.scale, height: 84.scale)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 16.scale
        
        let view = TopLocationsCollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeIndicatorsView() -> TopLocationsIndicatorsView {
        let view = TopLocationsIndicatorsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
