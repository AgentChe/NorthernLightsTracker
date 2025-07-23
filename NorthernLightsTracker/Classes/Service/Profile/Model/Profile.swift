//
//  Profile.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

struct Profile {
    let notificationToken: String?
    let kpThresholdEnabled: Bool?
    let cloudBreakEnabled: Bool?
    let location: Location?
    
    init(
        notificationToken: String?,
        kpThresholdEnabled: Bool?,
        cloudBreakEnabled: Bool?,
        location: Location?
    ) {
        self.notificationToken = notificationToken
        self.kpThresholdEnabled = kpThresholdEnabled
        self.cloudBreakEnabled = cloudBreakEnabled
        self.location = location
    }
    
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any]
        else { return nil }
        
        notificationToken = body["notification_token"] as? String
        kpThresholdEnabled = body["kp_threshold_enabled"] as? Bool
        cloudBreakEnabled = body["cloud_break_enabled"] as? Bool
        location = {
            guard
                let geo = body["geo"] as? [String: Any],
                let id = geo["id"] as? String,
                let address = geo["address"] as? String,
                let lat = geo["lat"] as? Double,
                let lon = geo["lon"] as? Double
            else { return nil }
            
            return Location(
                id: id,
                address: address,
                coordinate: Coordinate(lat: lat, lon: lon)
            )
        }()
    }
}
