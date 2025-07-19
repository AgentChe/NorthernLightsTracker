//
//  SolarTemplate.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

import Foundation

struct SolarTemplate {
    let id: String
    let name: String
    let image: URL
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let name = json["title"] as? String,
            let image: URL = {
                guard let string = json["image_url"] as? String else { return nil }
                return URL(string: string)
            }()
        else { return nil }
        
        self.id = id
        self.name = name
        self.image = image
    }
}

// MARK: Public
extension SolarTemplate {
    static func map(response: Any) -> [SolarTemplate]? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let items = body["items"] as? [[String: Any]]
        else { return nil }
        
        return items.compactMap { SolarTemplate(json: $0) }
    }
}
