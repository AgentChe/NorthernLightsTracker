//
//  ProfileMediator.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 15.07.2025.
//

import RxSwift
import RxCocoa

final class ProfileMediator {
    static let shared = ProfileMediator()
    
    private lazy var didChangeProfileTrigger = PublishRelay<Profile>()
    private lazy var didChangeKpThresholdEnabledTrigger = PublishRelay<Bool?>()
    private lazy var didChangeCloudBreakEnabledTrigger = PublishRelay<Bool?>()
    private lazy var didChangeGeoIdTrigger = PublishRelay<String?>()
    
    private init() {}
}

// MARK: Public
extension ProfileMediator {
    func update(profile: Profile) {
        didChangeProfileTrigger.accept(profile)
    }
    
    func update(kpThresholdEnabled: Bool?) {
        didChangeKpThresholdEnabledTrigger.accept(kpThresholdEnabled)
    }
    
    func update(cloudBreakEnabled: Bool?) {
        didChangeCloudBreakEnabledTrigger.accept(cloudBreakEnabled)
    }
    
    func update(geoId: String?) {
        didChangeGeoIdTrigger.accept(geoId)
    }
    
    var didChangeProfile: Signal<Profile> {
        didChangeProfileTrigger.asSignal()
    }
    
    var didChangeKpThresholdEnabled: Signal<Bool?> {
        didChangeKpThresholdEnabledTrigger.asSignal()
    }
    
    var didChangeCloudBreakEnabled: Signal<Bool?> {
        didChangeCloudBreakEnabledTrigger.asSignal()
    }
    
    var didChangeGeoId: Signal<String?> {
        didChangeGeoIdTrigger.asSignal()
    }
}
