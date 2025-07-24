//
//  TopLocationAnnotation.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 24.07.2025.
//

import UIKit
import MapKit

final class TopLocationAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?

    init(location: AuroraTopLocation) {
        self.coordinate = CLLocationCoordinate2D(
            latitude: location.coordinate.lat,
            longitude: location.coordinate.lon
        )
        self.title = location.name
        var parts = [String]()
        if let kp = location.kpIndex {
            parts.append("KP \(kp)")
        }
        if let cc = location.cloudCover {
            parts.append("Cloud cover \(cc)%")
        }
        self.subtitle = parts.joined(separator: ", ")
    }
}
