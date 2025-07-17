//
//  PushNotificationsQuery.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 16.07.2025.
//

import Foundation

final class PushNotificationsQuery {
    deinit {
        PushNotificationsManager.shared.remove(observer: self)
    }
    
    var didReceiveToken: ((String?) -> Void)?
}

// MARK: Public
extension PushNotificationsQuery {
    func request() {
        PushNotificationsManager.shared.add(observer: self)
        
        PushNotificationsManager.shared.requestAuthorization()
    }
}

// MARK: PushNotificationsDelegate
extension PushNotificationsQuery: PushNotificationsDelegate {
    func pushNotificationsDidReceive(token: String?) {
        PushNotificationsManager.shared.remove(observer: self)
        
        didReceiveToken?(token)
    }
    
    func pushNotificationsDidReceive(authorizationStatus: PushNotificationsAuthorizationStatus) {}
    func pushNotificationsDidReceive(model: PushNotificationsModel) {}
}
