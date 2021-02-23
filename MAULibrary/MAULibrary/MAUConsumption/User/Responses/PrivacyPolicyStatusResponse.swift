//
//  PrivacyPolicyStatusResponse.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 12/02/21.
//

import Foundation
import ObjectMapper

/// Object mapper response for the privacy policy status service
class PrivacyPolicyStatusResponse: Mappable {
    /// ID of the status
    var id: String?
    /// Client's CURP
    var curp: String?
    /// Client's privacy policies
    var privacyPolicies: [PrivacyPolicy]?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        curp <- map["curp"]
        privacyPolicies <- map["avisosPrivacidad"]
    }
}

/// Privacy Policy business line and acceptance by the user
class PrivacyPolicy: Mappable {
    /// Business data
    var businessLine: ValueID?
    /// Acceptance date of the privacy policy
    var acceptanceDate: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        businessLine <- map["lineaNegocio"]
        acceptanceDate <- map["fechaAceptacion"]
    }
}
