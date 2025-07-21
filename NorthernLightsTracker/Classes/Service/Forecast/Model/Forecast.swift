//
//  Forecast.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

struct Forecast {
    let aurora: ForecastAurora?
    let kp: ForecastKP?
    let cloudCover: ForecastCloudCover?
    let moonPhase: ForecastMoonPhase?
    let solarWind: ForecastSolarWind?
    let hemisphericPower: ForecastHemisphericPower?
    let planetaryA: ForecastPlanetaryA?
    
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any]
        else {
            return nil
        }
        
        aurora = {
            guard let json = body["aurora"] as? [String: Any] else { return nil }
            return ForecastAurora(json: json)
        }()
        kp = {
            guard let json = body["kp_forecast"] as? [String: Any] else { return nil }
            return ForecastKP(json: json)
        }()
        cloudCover = {
            guard let json = body["cloud_cover"] as? [String: Any] else { return nil }
            return ForecastCloudCover(json: json)
        }()
        moonPhase = {
            guard let json = body["moon_phase"] as? [String: Any] else { return nil }
            return ForecastMoonPhase(json: json)
        }()
        solarWind = {
            guard let json = body["solar_wind"] as? [String: Any] else { return nil }
            return ForecastSolarWind(json: json)
        }()
        hemisphericPower = {
            guard let json = body["hemispheric_power"] as? [String: Any] else { return nil }
            return ForecastHemisphericPower(json: json)
        }()
        planetaryA = {
            guard let json = body["planetary_a"] as? [String: Any] else { return nil }
            return ForecastPlanetaryA(json: json)
        }()
    }
}
