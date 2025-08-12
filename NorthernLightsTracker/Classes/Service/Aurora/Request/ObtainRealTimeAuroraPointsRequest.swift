//
//  ObtainRealTimeAuroraPointsRequest.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 12.08.2025.
//

import Alamofire

struct ObtainRealTimeAuroraPointsRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/aurora/map"
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
            "internal_id": internalId
        ]
    }
}
