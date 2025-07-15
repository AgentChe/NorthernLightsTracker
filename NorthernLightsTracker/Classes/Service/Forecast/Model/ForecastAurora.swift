//
//  ForecastAurora.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

import Foundation

struct ForecastAurora {
    let probability: Int
    let bestViewTime: PeakTime
    
    init?(json: [String: Any]) {
        guard
            let probability = json["probability"] as? Int,
            let bestViewTimes = json["best_view_time"] as? [TimeInterval],
            let bestViewTimeFrom = bestViewTimes[safe: 0],
            let bestViewTimeTo = bestViewTimes[safe: 1]
        else { return nil }
        
        self.probability = probability
        self.bestViewTime = PeakTime(from: bestViewTimeFrom, to: bestViewTimeTo)
    }
}
