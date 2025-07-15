//
//  ForecastKP.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

import Foundation

struct ForecastKP {
    struct KPTimeValue {
        let time: TimeInterval
        let value: Double
    }
    
    let current: Double
    let advice: String
    let level: String
    let forecast: [KPTimeValue]
    
    init?(json: [String: Any]) {
        guard
            let current = json["current"] as? Double,
            let advice = json["advice"] as? String,
            let level = json["level"] as? String
        else { return nil }
        
        self.current = current
        self.advice = advice
        self.level = level
        self.forecast = {
            guard let array = json["forecast"] as? [[String: Any]] else { return [] }
            return array.compactMap { json -> KPTimeValue? in
                guard
                    let time = json["time"] as? TimeInterval,
                    let value = json["value"] as? Double
                else { return nil }
                
                return KPTimeValue(time: time, value: value)
            }
        }()
    }
}
