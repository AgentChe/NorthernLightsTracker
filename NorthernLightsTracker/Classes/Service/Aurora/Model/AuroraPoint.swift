//
//  AuroraPoint.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 12.08.2025.
//

import Foundation

struct AuroraPoint {
    let lon: Double   // 0...359 from NOAA
    let lat: Double   // -90...90
    let probability: Double // 0...100 (%)
}

// MARK: Public
extension AuroraPoint {
    static func make(response: Any) -> [AuroraPoint] {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let triples = body["all_coordinates"] as? [[Any]]
        else { return [] }
        
        return triples.compactMap { array -> AuroraPoint? in
            guard
                let lon = (array[0] as? NSNumber)?.doubleValue,
                let lat = (array[1] as? NSNumber)?.doubleValue,
                let probability = (array[2] as? NSNumber)?.doubleValue
            else { return nil }
            
            return AuroraPoint(
                lon: lon,
                lat: lat,
                probability: probability
            )
        }
    }
}
