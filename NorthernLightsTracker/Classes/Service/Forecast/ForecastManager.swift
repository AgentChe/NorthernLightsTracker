//
//  ForecastManager.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

import RxSwift

protocol ForecastManagerProtocol {
    func obtainForecast() -> Single<Forecast?>
    func obtainSolarTemplates() -> Single<[SolarTemplate]?>
    func obtainSolar(id: String) -> Single<Solar?>
}

final class ForecastManager {
    private lazy var restAPITransport = RestAPITransport()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: ForecastManagerProtocol
extension ForecastManager: ForecastManagerProtocol {
    func obtainForecast() -> Single<Forecast?> {
        let request = ObtainForecastRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { Forecast(response: $0) }
    }
    
    func obtainSolarTemplates() -> Single<[SolarTemplate]?> {
        let request = ObtainSolarTemplatesRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { SolarTemplate.map(response: $0) }
    }
    
    func obtainSolar(id: String) -> Single<Solar?> {
        let request = ObtainSolarRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { Solar(response: $0) }
    }
}
