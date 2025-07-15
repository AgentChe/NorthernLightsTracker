//
//  LocationHistory.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

struct LocationHistory {
    let current: String?
    let recentSearch: [String]
    
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any]
        else { return nil }
        
        current = body["current_location"] as? String
        recentSearch = body["recent_search"] as? [String] ?? []
    }
}
