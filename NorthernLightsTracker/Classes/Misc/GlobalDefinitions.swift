//
//  GlobalDefinitions.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

// TODO
final class GlobalDefinitions {
    static let domain = "https://lights.korrekted.com"
    static let apiKey = "WlHaWDqicvSbKiTkrs"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "FCOhobiDpN3gdPo4"
    
    static let applicationTag = "GIS_REAL_ESTATE"
    static let amplitudeApiKey = "d4ad5c33d23d7a891e9c68de9471f36b"
    
    static let termsOfServiceUrl = URL(string: "https://appslaunchpad.com/terms")!
    static let privacyPolicyUrl = URL(string: "https://appslaunchpad.com/policy")!
    static let contactUsUrl = URL(string: "https://appslaunchpad.com/contact")!
    
    enum Paygate {
        static let yearly = "com.gisrealestate.yearly"
        static let weekly = "com.gisrealestate.weekly"
    }
}
