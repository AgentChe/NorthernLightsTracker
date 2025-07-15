//
//  AuroraMapOval.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

import Foundation

struct AuroraMapOval {
    let north: URL?
    let south: URL?
    
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any]
        else { return nil }
        
        north = {
            guard let string = body["north"] as? String else { return nil }
            let encoded = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? string
            return URL(string: encoded)
        }()
        south = {
            guard let string = body["south"] as? String else { return nil }
            let encoded = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? string
            return URL(string: encoded)
        }()
    }
}
