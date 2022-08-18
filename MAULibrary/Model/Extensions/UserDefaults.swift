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
    
    var arrayFactors: [Factor] {
        get {
            let decoder = JSONDecoder()
            guard let factorData = self.data(forKey: "arrayFactors") else { return [] }
            let arrayFactors = try! decoder.decode([Factor].self, from: factorData)
            
            return arrayFactors
        }
        set(arrayFactors) {
            let encoder = JSONEncoder()
            let factorData = try! encoder.encode(arrayFactors)
            
            self.set(factorData, forKey: "arrayFactors")
        }
    }
    
    var arrayCriticalityMatrix: [Factor] {
        get {
            let decoder = JSONDecoder()
            guard let factorData = self.data(forKey: "arrayCriticalityMatrix") else { return [] }
            let arrayFactors = try! decoder.decode([Factor].self, from: factorData)
            
            return arrayFactors
        }
        set(arrayFactors) {
            let encoder = JSONEncoder()
            let factorData = try! encoder.encode(arrayFactors)
            
            self.set(factorData, forKey: "arrayCriticalityMatrix")
        }
    }
    
    var canUseEmailTokenDM: Bool {
        get {
            return self.bool(forKey: "canUseEmailTokenDM")
        }
        set(canUseEmailTokenDM) {
            self.set(canUseEmailTokenDM, forKey: "canUseEmailTokenDM")
        }
    }
    
    var canUseSMSTokenDM: Bool {
        get {
            return self.bool(forKey: "canUseSMSTokenDM")
        }
        set(canUseSMSTokenDM) {
            self.set(canUseSMSTokenDM, forKey: "canUseSMSTokenDM")
        }
    }
    
    var isUserEnrolled: Bool {
        get {
            return self.bool(forKey: "userEnrolled")
        }
        set(isUserEnrolled) {
            self.set(isUserEnrolled, forKey: "userEnrolled")
        }
    }

    var tokenOperation: String {
        get {
            return self.string(forKey: "tokenOperation") ?? ""
        }
        set(tokenOperation) {
            self.set(tokenOperation, forKey: "tokenOperation")
        }
    }
    
    var uuidSession: String {
        get {
            return self.string(forKey: "uuidSession") ?? ""
        }
        set(uuidSession) {
            self.set(uuidSession, forKey: "uuidSession")
        }
    }
}
