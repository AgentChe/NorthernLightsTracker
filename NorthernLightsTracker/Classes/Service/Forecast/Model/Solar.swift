//
//  Solar.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

import Foundation

struct Solar {
    let title: String
    let image: URL
    let description: String
    let faq: [SolarFAQ]
    
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let title = body["title"] as? String,
            let image: URL = {
                guard let string = body["image_url"] as? String else { return nil }
                return URL(string: string)
            }(),
            let description = body["description"] as? String,
            let faqArray = body["faq"] as? [[String: Any]]
        else { return nil }
        
        self.title = title
        self.image = image
        self.description = description
        self.faq = faqArray.compactMap { SolarFAQ(json: $0) }
    }
}
