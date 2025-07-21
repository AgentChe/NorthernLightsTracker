//
//  ForecastPlanetaryA.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

struct ForecastPlanetaryA {
    let advice: String
    let ap: Int
    let activity: String
    
    init?(json: [String: Any]) {
        guard
            let advice = json["advice"] as? String,
            let ap = json["ap"] as? Int,
            let activity = json["activity"] as? String
        else { return nil }
        
        self.advice = advice
        self.ap = ap
        self.activity = activity
    }
}
