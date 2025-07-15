//
//  AuroraMapDetails.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

struct AuroraMapDetails {
    let locationName: String
    let coordinate: Coordinate
    let auroraPercent: Int
    
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let locationName = body["location_name"] as? String,
            let lat = body["lat"] as? Double,
            let lon = body["lon"] as? Double,
            let auroraPercent = body["aurora_percent"] as? Int
        else { return nil }
        
        self.locationName = locationName
        self.coordinate = Coordinate(lat: lat, lon: lon)
        self.auroraPercent = auroraPercent
    }
}
