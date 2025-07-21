//
//  ForecastCloudCover.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

import Foundation

struct ForecastCloudCover {
    struct KPTimeCover {
        let time: Int
        let cover: Int
    }
    
    let current: Double
    let description: String
    let advice: String
    let forecast: [KPTimeCover]
    
    init?(json: [String: Any]) {
        guard
            let current = json["current"] as? Double,
            let description = json["description"] as? String,
            let advice = json["advice"] as? String
        else { return nil }
        
        self.current = current
        self.description = description
        self.advice = advice
        self.forecast = {
            guard let array = json["hourly_forecast"] as? [[String: Any]] else { return [] }
            return array.compactMap { json -> KPTimeCover? in
                guard
                    let time = json["time"] as? Int,
                    let cover = json["cover"] as? Int
                else { return nil }
                
                return KPTimeCover(time: time, cover: cover)
            }
        }()
    }
}
