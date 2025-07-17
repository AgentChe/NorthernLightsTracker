//
//  OnboardingCombineData.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 16.07.2025.
//

final class OnboardingCombineData {
    struct CombineData {
        let notificationsToken: String?
        let geoId: String
    }
    
    private var notificationsToken: String?
    private var geoId: String?
}

// MARK: Public
extension OnboardingCombineData {
    func setup(notificationsToken: String?) {
        self.notificationsToken = notificationsToken
    }
    
    func setup(geoId: String) {
        self.geoId = geoId
    }
    
    func make() -> CombineData? {
        guard let geoId else { return nil }
        
        return CombineData(
            notificationsToken: notificationsToken,
            geoId: geoId
        )
    }
}
