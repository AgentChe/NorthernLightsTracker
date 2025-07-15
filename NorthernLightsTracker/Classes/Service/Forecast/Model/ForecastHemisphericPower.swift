//
//  ForecastHemisphericPower.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

struct ForecastHemisphericPower {
    let advice: String
    let power: Int
    let region: String
    
    init?(json: [String: Any]) {
        guard
            let advice = json["advice"] as? String,
            let power = json["power"] as? Int,
            let region = json["region"] as? String
        else { return nil }
        
        self.advice = advice
        self.power = power
        self.region = region
    }
}
