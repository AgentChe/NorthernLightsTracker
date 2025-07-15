//
//  SearchLocationsRequest.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

import Alamofire

struct SearchLocationsRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let text: String
    let page: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/location/search"
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
            "text": text,
            "page": page
        ]
    }
}
