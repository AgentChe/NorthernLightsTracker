//
//  GlobalDefinitions.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

final class GlobalDefinitions {
    static let domain = "https://lights.korrekted.com"
    static let apiKey = "WlHaWDqicvSbKiTkrs"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "DqEssmYWDUGxeEf3"
    
    static let applicationTag = "GIS_REAL_ESTATE"
    static let amplitudeApiKey = "d4ad5c33d23d7a891e9c68de9471f36b"
    
    static let termsOfServiceUrl = URL(string: "https://sergei-mobile.com/eula.html")!
    static let privacyPolicyUrl = URL(string: "https://sergei-mobile.com/policy.html")!
    static let contactUsUrl = URL(string: "https://sergei-mobile.com/contact.html")!
    
    enum Paygate {
        static let yearly = "com.northernlightstracker.yearly"
        static let weekly = "com.northernlightstracker.weekly"
    }
}
