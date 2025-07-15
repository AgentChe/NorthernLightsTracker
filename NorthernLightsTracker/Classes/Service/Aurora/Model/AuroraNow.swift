//
//  AuroraNow.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

import Foundation

struct AuroraNow {
    let updatedTime: TimeInterval?
    let cloudCover: Int?
    let kpIndex: Double?
    let peakTime: PeakTime?
    let status: String?
    
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any]
        else { return nil }
        
        updatedTime = body["updated_time"] as? TimeInterval
        cloudCover = body["cloud_cover"] as? Int
        kpIndex = body["kp_index"] as? Double
        peakTime = {
            guard
                let array = body["peak_time"] as? [TimeInterval],
                let from = array[safe: 0],
                let to = array[safe: 1]
            else { return nil }
            
            return PeakTime(from: from, to: to)
        }()
        status = body["status"] as? String
    }
}
