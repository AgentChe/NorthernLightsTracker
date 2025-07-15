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
    let geoId: String?
    
    init(
        notificationToken: String?,
        kpThresholdEnabled: Bool?,
        cloudBreakEnabled: Bool?,
        geoId: String?
    ) {
        self.notificationToken = notificationToken
        self.kpThresholdEnabled = kpThresholdEnabled
        self.cloudBreakEnabled = cloudBreakEnabled
        self.geoId = geoId
    }
    
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any]
        else { return nil }
        
        notificationToken = body["notification_token"] as? String
        kpThresholdEnabled = body["kp_threshold_enabled"] as? Bool
        cloudBreakEnabled = body["cloud_break_enabled"] as? Bool
        geoId = {
            guard let geo = body["geo"] as? [String: Any] else { return nil }
            return geo["id"] as? String
        }()
    }
}
