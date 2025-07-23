//
//  OnboardingCombineData.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 16.07.2025.
//

final class OnboardingCombineData {
    struct CombineData {
        let notificationsToken: String?
        let location: Location
    }
    
    private var notificationsToken: String?
    private var location: Location?
}

// MARK: Public
extension OnboardingCombineData {
    func setup(notificationsToken: String?) {
        self.notificationsToken = notificationsToken
    }
    
    func setup(location: Location) {
        self.location = location
    }
    
    func make() -> CombineData? {
        guard let location else { return nil }
        
        return CombineData(
            notificationsToken: notificationsToken,
            location: location
        )
    }
}
