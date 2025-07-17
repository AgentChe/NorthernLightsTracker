//
//  SetProfileRequest.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

import Alamofire

struct SetProfileRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let notificationToken: String?
    let kpThresholdEnabled: Bool?
    let cloudBreakEnabled: Bool?
    let geoId: String?
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/profile/attributes"
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
            "attrs": {
                let attrs: Parameters = [
                    "notification_token": notificationToken ?? NSNull(),
                    "kp_threshold_enabled": kpThresholdEnabled ?? NSNull(),
                    "cloud_break_enabled": cloudBreakEnabled ?? NSNull(),
                    "geo_id": geoId ?? NSNull()
                ]
                return attrs
            }()
        ]
    }
}
