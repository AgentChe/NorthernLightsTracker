//
//  LocationAuthorizationQuery.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 16.07.2025.
//

import CoreLocation

final class LocationAuthorizationQuery: NSObject {
    enum Status {
        case authorized, denied
    }
    
    private lazy var manager = CLLocationManager()
    
    private let didComplete: (Status) -> Void
    
    init(didComplete: @escaping (Status) -> Void) {
        self.didComplete = didComplete
        
        super.init()
    }
}

// MARK: Public
extension LocationAuthorizationQuery {
    func request() {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            didComplete(.authorized)
        case .notDetermined:
            manager.delegate = self
            manager.requestWhenInUseAuthorization()
        default:
            didComplete(.denied)
        }
    }
}

// MARK: CLLocationManagerDelegate
extension LocationAuthorizationQuery: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            didComplete(.authorized)
        case .notDetermined:
            break
        default:
            didComplete(.denied)
        }
    }
}
