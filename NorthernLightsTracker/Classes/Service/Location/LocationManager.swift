//
//  LocationManager.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

import RxSwift

protocol LocationManagerProtocol {
    func searchLocations(text: String, page: Int) -> Single<Page<[Location]>?>
    func obtainHistory() -> Single<LocationHistory?>
}

final class LocationManager {
    private lazy var restAPITransport = RestAPITransport()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: LocationManagerProtocol
extension LocationManager: LocationManagerProtocol {
    func searchLocations(text: String, page: Int) -> Single<Page<[Location]>?> {
        let request = SearchLocationsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            text: text,
            page: page
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { Location.map(response: $0) }
    }
    
    func obtainHistory() -> Single<LocationHistory?> {
        let request = ObtainLocationHistoryRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { LocationHistory(response: $0) }
    }
}
