//
//  NowTableElement.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 23.07.2025.
//

import Foundation

enum NowTableElement {
    case updated(TimeInterval)
    case status(String)
    case indicators(NowTableIndicatorsElement)
    case openMapRoute
    case currentLocation(Location)
    case topLocationsRoute
    case noTopLocations
}

struct NowTableIndicatorsElement {
    let cloudCover: Int?
    let kpIndex: Double?
    let peakTime: PeakTime?
}
