//
//  ForecastTableElement.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 20.07.2025.
//

final class ForecastTableElement {
    enum Element {
        case aurora(ForecastAurora)
        case kpIndex(ForecastKP)
        case cloudCover(ForecastCloudCover)
        case moonPhase(ForecastMoonPhase)
        case solarWind(ForecastSolarWind)
        case hemisphericPower(ForecastHemisphericPower)
        case planetaryA(ForecastPlanetaryA)
    }
    
    let element: Element
    var opened: Bool
    
    init(element: Element, opened: Bool) {
        self.element = element
        self.opened = opened
    }
}
