//
//  ProfileManager.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 06.09.2024.
//

import RxSwift
import RxCocoa

protocol ProfileManagerProtocol: AnyObject {
    func create() -> Single<RequestResult>
    func binding() -> Single<RequestResult>
    func setup(profile: Profile) -> Single<RequestResult>
    func update(notificationToken: String) -> Single<RequestResult>
    func update(kpThresholdEnabled: Bool) -> Single<RequestResult>
    func update(cloudBreakEnabled: Bool) -> Single<RequestResult>
    func update(geoId: String) -> Single<RequestResult>
    func obtainProfile(forceUpdate: Bool) -> Single<Profile?>
}

final class ProfileManager {
    private lazy var restApiTransport = RestAPITransport()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: ProfileManagerProtocol
extension ProfileManager: ProfileManagerProtocol {
    func create() -> Single<RequestResult> {
        let request = ProfileCreateRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
    }
    
    func binding() -> Single<RequestResult> {
        let request = ProfileBindingRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
    }
    
    func setup(profile: Profile) -> Single<RequestResult> {
        let request = SetProfileRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            notificationToken: profile.notificationToken,
            kpThresholdEnabled: profile.kpThresholdEnabled,
            cloudBreakEnabled: profile.cloudBreakEnabled,
            geoId: profile.geoId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { [weak self] result in
                guard result.success else { return }
                
                self?.store(profile: profile, notify: true)
            })
    }
    
    func update(notificationToken: String) -> Single<RequestResult> {
        cachedProfile()
            .flatMap { [weak self] profile -> Single<RequestResult> in
                guard let self else { return .never() }
                
                let request = SetProfileRequest(
                    anonymousId: sessionManager.anonymousId,
                    internalId: sessionManager.internalId,
                    notificationToken: notificationToken,
                    kpThresholdEnabled: profile.kpThresholdEnabled,
                    cloudBreakEnabled: profile.cloudBreakEnabled,
                    geoId: profile.geoId
                )
                
                return restApiTransport
                    .callServerApi(requestBody: request)
                    .map { RequestResult.map(response: $0) }
            }
    }
    
    func update(kpThresholdEnabled: Bool) -> Single<RequestResult> {
        cachedProfile()
            .flatMap { [weak self] profile -> Single<RequestResult> in
                guard let self else { return .never() }
                
                let request = SetProfileRequest(
                    anonymousId: sessionManager.anonymousId,
                    internalId: sessionManager.internalId,
                    notificationToken: PushNotificationsManager.shared.fcmToken,
                    kpThresholdEnabled: kpThresholdEnabled,
                    cloudBreakEnabled: profile.cloudBreakEnabled,
                    geoId: profile.geoId
                )
                
                return restApiTransport
                    .callServerApi(requestBody: request)
                    .map { RequestResult.map(response: $0) }
                    .do(onSuccess: { [weak self] result in
                        guard result.success else { return }
                        
                        self?.store(kpThresholdEnabled: kpThresholdEnabled)
                    })
            }
    }
    
    func update(cloudBreakEnabled: Bool) -> Single<RequestResult> {
        cachedProfile()
            .flatMap { [weak self] profile -> Single<RequestResult> in
                guard let self else { return .never() }
                
                let request = SetProfileRequest(
                    anonymousId: sessionManager.anonymousId,
                    internalId: sessionManager.internalId,
                    notificationToken: PushNotificationsManager.shared.fcmToken,
                    kpThresholdEnabled: profile.kpThresholdEnabled,
                    cloudBreakEnabled: cloudBreakEnabled,
                    geoId: profile.geoId
                )
                
                return restApiTransport
                    .callServerApi(requestBody: request)
                    .map { RequestResult.map(response: $0) }
                    .do(onSuccess: { [weak self] result in
                        guard result.success else { return }
                        
                        self?.store(cloudBreakEnabled: cloudBreakEnabled)
                    })
            }
    }
    
    func update(geoId: String) -> Single<RequestResult> {
        cachedProfile()
            .flatMap { [weak self] profile -> Single<RequestResult> in
                guard let self else { return .never() }
                
                let request = SetProfileRequest(
                    anonymousId: sessionManager.anonymousId,
                    internalId: sessionManager.internalId,
                    notificationToken: PushNotificationsManager.shared.fcmToken,
                    kpThresholdEnabled: profile.kpThresholdEnabled,
                    cloudBreakEnabled: profile.cloudBreakEnabled,
                    geoId: geoId
                )
                
                return restApiTransport
                    .callServerApi(requestBody: request)
                    .map { RequestResult.map(response: $0) }
                    .do(onSuccess: { [weak self] result in
                        guard result.success else { return }
                        
                        self?.store(geoId: geoId)
                    })
            }
    }
    
    func obtainProfile(forceUpdate: Bool) -> Single<Profile?> {
        forceUpdate ? loadProfile() : cachedProfile().map { profile -> Profile? in profile }
    }
}

// MARK: Private
private extension ProfileManager {
    enum Constants {
        static let kpThresholdEnabledKey = "profile_manager_kpThresholdEnabled"
        static let cloudBreakEnabledKey = "profile_manager_cloudBreakEnabled"
        static let geoIdKey = "profile_manager_geoId"
    }
    
    func store(profile: Profile, notify: Bool) {
        let cloudBreakEnabledData: Data? = {
            guard let cloudBreakEnabled = profile.cloudBreakEnabled else { return nil }
            return try? JSONEncoder().encode(cloudBreakEnabled)
        }()
        let kpThresholdEnabledData: Data? = {
            guard let kpThresholdEnabled = profile.kpThresholdEnabled else { return nil }
            return try? JSONEncoder().encode(kpThresholdEnabled)
        }()
        let geoIdData: Data? = {
            guard let geoId = profile.geoId else { return nil }
            return try? JSONEncoder().encode(geoId)
        }()
        
        UserDefaults.standard.set(cloudBreakEnabledData, forKey: Constants.cloudBreakEnabledKey)
        UserDefaults.standard.set(kpThresholdEnabledData, forKey: Constants.kpThresholdEnabledKey)
        UserDefaults.standard.set(geoIdData, forKey: Constants.geoIdKey)
        
        if notify {
            ProfileMediator.shared.update(profile: profile)
        }
    }
    
    func store(kpThresholdEnabled: Bool?) {
        let data: Data? = {
            guard let kpThresholdEnabled else { return nil }
            return try? JSONEncoder().encode(kpThresholdEnabled)
        }()
        
        UserDefaults.standard.set(data, forKey: Constants.kpThresholdEnabledKey)
        
        ProfileMediator.shared.update(kpThresholdEnabled: kpThresholdEnabled)
    }
    
    func store(cloudBreakEnabled: Bool?) {
        let data: Data? = {
            guard let cloudBreakEnabled else { return nil }
            return try? JSONEncoder().encode(cloudBreakEnabled)
        }()
        
        UserDefaults.standard.set(data, forKey: Constants.cloudBreakEnabledKey)
        
        ProfileMediator.shared.update(cloudBreakEnabled: cloudBreakEnabled)
    }
    
    func store(geoId: String?) {
        let data: Data? = {
            guard let geoId else { return nil }
            return try? JSONEncoder().encode(geoId)
        }()
        
        UserDefaults.standard.set(data, forKey: Constants.geoIdKey)
        
        ProfileMediator.shared.update(geoId: geoId)
    }
    
    func loadProfile() -> Single<Profile?> {
        let request = ObtainProfileRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { Profile(response: $0) }
            .do(onSuccess: { [weak self] profile in
                guard let profile else { return }
                
                self?.store(profile: profile, notify: false)
            })
    }
    
    func cachedProfile() -> Single<Profile> {
        Single<Profile>.create { single in
            let kpThresholdEnabled: Bool? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.kpThresholdEnabledKey) else { return nil }
                return try? JSONDecoder().decode(Bool.self, from: data)
            }()
            
            let cloudBreakEnabled: Bool? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.cloudBreakEnabledKey) else { return nil }
                return try? JSONDecoder().decode(Bool.self, from: data)
            }()
            
            let geoId: String? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.geoIdKey) else { return nil }
                return try? JSONDecoder().decode(String.self, from: data)
            }()
            
            let profile = Profile(
                notificationToken: PushNotificationsManager.shared.fcmToken,
                kpThresholdEnabled: kpThresholdEnabled,
                cloudBreakEnabled: cloudBreakEnabled,
                geoId: geoId
            )
            
            single(.success(profile))
            
            return Disposables.create()
        }
    }
}
