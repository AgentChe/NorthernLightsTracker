//
//  ForecastMoonPhase.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

struct ForecastMoonPhase {
    let phase: String
    let advice: String
    let illumination: Int
    
    init?(json: [String: Any]) {
        guard
            let phase = json["phase"] as? String,
            let advice = json["advice"] as? String,
            let illumination = json["illumination"] as? Int
        else { return nil }
        
        self.phase = phase
        self.advice = advice
        self.illumination = illumination
    }
}
