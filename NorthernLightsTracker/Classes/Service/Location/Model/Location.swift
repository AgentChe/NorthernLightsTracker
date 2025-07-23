//
//  Location.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

struct Location: Codable {
    let id: String
    let address: String
    let coordinate: Coordinate
    
    init(
        id: String,
        address: String,
        coordinate: Coordinate
    ) {
        self.id = id
        self.address = address
        self.coordinate = coordinate
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let address = json["address"] as? String,
            let lat = json["lat"] as? Double,
            let lon = json["lon"] as? Double
        else { return nil }
        
        self.id = id
        self.address = address
        self.coordinate = Coordinate(lat: lat, lon: lon)
    }
}

// MARK: Public
extension Location {
    static func map(response: Any) -> Page<[Location]>? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let pageInfo: PageInfo = {
                guard let pagination = body["pagination"] as? [String: Any] else { return nil }
                return PageInfo(json: pagination)
            }(),
            let items = body["items"] as? [[String: Any]]
        else { return nil }
        
        let elements = items.compactMap { Location(json: $0) }
        
        return Page(info: pageInfo, elements: elements)
    }
}
