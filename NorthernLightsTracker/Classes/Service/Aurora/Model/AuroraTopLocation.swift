//
//  AuroraTopLocation.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

import Foundation

struct AuroraTopLocation {
    let name: String
    let cloudCover: Int?
    let coordinate: Coordinate
    let kpIndex: Double?
    let peakTime: PeakTime?
    let status: String?
    
    init?(json: [String: Any]) {
        guard
            let name = json["name"] as? String,
            let lat = json["lat"] as? Double,
            let lon = json["lon"] as? Double
        else { return nil }
        
        self.name = name
        self.cloudCover = json["cloud_cover"] as? Int
        self.coordinate = Coordinate(lat: lat, lon: lon)
        self.kpIndex = json["kp_index"] as? Double
        self.peakTime = {
            guard
                let array = json["peak_time"] as? [TimeInterval],
                let from = array[safe: 0],
                let to = array[safe: 1]
            else { return nil }
            
            return PeakTime(from: from, to: to)
        }()
        self.status = json["status"] as? String
    }
}

// MARK: Public
extension AuroraTopLocation {
    static func map(response: Any) -> [AuroraTopLocation] {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let items = body["items"] as? [[String: Any]]
        else { return [] }
        
        return items.compactMap { AuroraTopLocation(json: $0) }
    }
}
