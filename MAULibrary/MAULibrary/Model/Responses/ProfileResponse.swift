//
//  ProfileResponse.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 28/01/21.
//

import Foundation
import ObjectMapper

/**
 For the profile response, if the authentication (email or sms) data has status ID = 136, is valid. For facial and dactilar, must be status ID = 201.
 */
class ProfileResponse: Mappable {
    /// Client CURP data
    var curpData: CURPData?
    /// Client phone number data
    var phoneNumberData: PhoneNumberData?
    /// Client email data
    var emailData: EmailData?
    /// Client facial biometrics data
    var facialBiometricsData: FacialBiometricsData?
    /// Client fingerprint biometrics data
    var fingerprintBiometricsData: FingerprintBiometricsData?
    /// Client BAU data
    var bauData: BAUData?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        curpData <- map["curp"]
        phoneNumberData <- map["celular"]
        emailData <- map["correo"]
        facialBiometricsData <- map["biometriaFacial"]
        fingerprintBiometricsData <- map["biometriaDactilar"]
        bauData <- map["datosBAU"]
    }
}

/// Data of client CURP
class CURPData: Mappable {
    /// Client CURP
    var curp: String?
    /// Status of the CURP
    var status: ValueID?
    /// Origin of the CURP
    var origin: ValueID?
    /// Last update date of the CURP
    var updateDate: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        curp <- map["curp"]
        status <- map["estado"]
        origin <- map["origen"]
        updateDate <- map["fechaActualizacion"]
    }
}

/// Data of client phone number
class PhoneNumberData: Mappable {
    /// Client phone number
    var phoneNumber: String?
    /// Status of the phone number
    var status: ValueID?
    /// Origin of the phone number
    var origin: ValueID?
    /// Last update date of the phone number
    var updateDate: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        phoneNumber <- map["celular"]
        status <- map["estado"]
        origin <- map["origen"]
        updateDate <- map["fechaActualizacion"]
    }
}

/// Data of client email
class EmailData: Mappable {
    /// Client email
    var email: String?
    /// Status of the email
    var status: ValueID?
    /// Origin of the email
    var origin: ValueID?
    /// Last update date of the email
    var updateDate: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        email <- map["correo"]
        status <- map["estado"]
        origin <- map["origen"]
        updateDate <- map["fechaActualizacion"]
    }
}

/// Data of client facial biometrics
class FacialBiometricsData: Mappable {
    /// Status of the facial biometrics
    var status: ValueID?
    /// Origin of the facial biometrics
    var origin: ValueID?
    /// Last update date of the facial biometrics
    var updateDate: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        status <- map["estado"]
        origin <- map["origen"]
        updateDate <- map["fechaActualizacion"]
    }
}

/// Data of client fingerprint biometrics
class FingerprintBiometricsData: Mappable {
    /// Status of the fingerprint biometrics
    var status: ValueID?
    /// Origin of the fingerprint biometrics
    var origin: ValueID?
    /// Last update date of the fingerprint biometrics
    var updateDate: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        status <- map["estado"]
        origin <- map["origen"]
        updateDate <- map["fechaActualizacion"]
    }
}

/// BAU Data
class BAUData: Mappable {
    /// Role of the client from BAU
    var role: ValueID?
    /// Origin of the BAU data
    var origin: ValueID?
    /// Register date in BAU
    var registerDate: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        role <- map["rol"]
        origin <- map["origen"]
        registerDate <- map["fechaRegistro"]
    }
}

//Generic class with ID-Value relation
class ValueID: Mappable {
    ///ID of the element
    var id: String?
    ///Current value of the element (linked with the ID)
    var value: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        value <- map["valor"]
    }
}
