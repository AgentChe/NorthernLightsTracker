//
//  AuroraManager.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

import RxSwift

protocol AuroraManagerProtocol {
    func obtainAuroraNow() -> Single<AuroraNow?>
    func obtainAuroraMapDetails(coordinate: Coordinate) -> Single<AuroraMapDetails?>
    func obtainAuroraMapOval() -> Single<AuroraMapOval?>
    func obtainAuroraTopLocations() -> Single<[AuroraTopLocation]>
    func obtainRealTimeAuroraPoints() -> Single<[AuroraPoint]>
}

final class AuroraManager {
    private lazy var restAPITransport = RestAPITransport()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: AuroraManagerProtocol
extension AuroraManager: AuroraManagerProtocol {
    func obtainAuroraNow() -> Single<AuroraNow?> {
        let request = ObtainAuroraNowRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { AuroraNow(response: $0) }
    }
    
    func obtainAuroraMapDetails(coordinate: Coordinate) -> Single<AuroraMapDetails?> {
        let request = ObtainAuroraMapDetailsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            lat: coordinate.lat,
            lon: coordinate.lon
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { AuroraMapDetails(response: $0) }
    }
    
    func obtainAuroraMapOval() -> Single<AuroraMapOval?> {
        let request = ObtainAuroraMapOvalRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { AuroraMapOval(response: $0) }
    }
    
    func obtainAuroraTopLocations() -> Single<[AuroraTopLocation]> {
        let request = ObtainAuroraTopsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { AuroraTopLocation.map(response: $0) }
    }
    
    func obtainRealTimeAuroraPoints() -> Single<[AuroraPoint]> {
        let request = ObtainRealTimeAuroraPointsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { AuroraPoint.make(response: $0) }
    }
}
