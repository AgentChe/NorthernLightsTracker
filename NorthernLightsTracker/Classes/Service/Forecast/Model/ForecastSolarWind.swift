//
//  ForecastSolarWind.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

struct ForecastSolarWind {
    let advice: String
    let speed: Int
    let density: Double
    let bz: Double
    
    init?(json: [String: Any]) {
        guard
            let advice = json["advice"] as? String,
            let speed = json["speed"] as? Int,
            let density = json["density"] as? Double,
            let bz = json["bz"] as? Double
        else { return nil }
        
        self.advice = advice
        self.speed = speed
        self.density = density
        self.bz = bz
    }
}
