//
//  UserDefaults.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 04/12/20.
//

import Foundation

extension UserDefaults {
    /**
     Access token for the API requests
     */
    var token: String {
        get {
            return self.string(forKey: "token") ?? ""
        }
        set(temporalToken) {
            self.set(temporalToken, forKey: "token")
        }
    }
    
    /**
     Access token for Profuturo Móvil Consumption
     */
    var mauToken: String {
        get {
            return self.string(forKey: "mauToken") ?? ""
        }
        set(mauToken) {
            self.set(mauToken, forKey: "mauToken")
        }
    }
    
    var userInformation: User {
        get {
            let decoder = JSONDecoder()
            let userData = self.data(forKey: "userInformation")!
            let user = try! decoder.decode(User.self, from: userData)
            
            return user
        }
        set(userInformation) {
            let encoder = JSONEncoder()
            let userData = try! encoder.encode(userInformation)
            
            self.set(userData, forKey: "userInformation")
        }
    }
    
    var canUseFacialAuthentication: Bool {
        get {
            return self.bool(forKey: "canUseFacialAuthentication")
        }
        set(canUseFacialAuthentication) {
            self.set(canUseFacialAuthentication, forKey: "canUseFacialAuthentication")
        }
    }
    
    var canUseSMSTokenAuthentication: Bool {
        get {
            return self.bool(forKey: "canUseSMSTokenAuthentication")
        }
        set(canUseSMSTokenAuthentication) {
            self.set(canUseSMSTokenAuthentication, forKey: "canUseSMSTokenAuthentication")
        }
    }
    
    var canUseEmailTokenAuthentication: Bool {
        get {
            return self.bool(forKey: "canUseEmailTokenAuthentication")
        }
        set(canUseEmailTokenAuthentication) {
            self.set(canUseEmailTokenAuthentication, forKey: "canUseEmailTokenAuthentication")
        }
    }
    
    var canUseTokenAuthentication: Bool {
        get {
            return self.canUseEmailTokenAuthentication || self.canUseSMSTokenAuthentication
        }
    }
    
    var hasDailyAttemptsOfSMS: Bool {
        get {
            return self.bool(forKey: "hasDailyAttemptsOfSMS")
        }
        set(hasDailyAttemptsOfSMS) {
            self.set(hasDailyAttemptsOfSMS, forKey: "hasDailyAttemptsOfSMS")
        }
    }
    
    var hasDailyAttemptsOfEmail: Bool {
        get {
            return self.bool(forKey: "hasDailyAttemptsOfEmail")
        }
        set(hasDailyAttemptsOfEmail) {
            self.set(hasDailyAttemptsOfEmail, forKey: "hasDailyAttemptsOfEmail")
        }
    }
    
    var hasDailyAttemptsOfFacial: Bool {
        get {
            return self.bool(forKey: "hasDailyAttemptsOfFacial")
        }
        set(hasDailyAttemptsOfFacial) {
            self.set(hasDailyAttemptsOfFacial, forKey: "hasDailyAttemptsOfFacial")
        }
    }
}
