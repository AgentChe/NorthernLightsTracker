//
//  ObtainAuroraMapDetailsRequest.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

import Alamofire

struct ObtainAuroraMapDetailsRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let lat: Double
    let lon: Double
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/aurora/map/details"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var headers: HTTPHeaders? {
        [
            "Access-Token": GlobalDefinitions.apiKey
        ]
    }
    
    var parameters: Parameters? {
        [
            "anonymous_id": anonymousId,
            "internal_id": internalId,
            "lat": lat,
            "lon": lon
        ]
    }
}
