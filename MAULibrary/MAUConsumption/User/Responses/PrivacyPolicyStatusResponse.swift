//
//  PrivacyPolicyStatusResponse.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 12/02/21.
//

import Foundation
import ObjectMapper

/// Object mapper response for the privacy policy status service
public class PrivacyPolicyStatusResponse: Mappable {
    /// ID of the status
    public var id: String?
    /// Client's CURP
    public var curp: String?
    /// Client's privacy policies
    public var privacyPolicies: [PrivacyPolicy]?
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        id <- map["id"]
        curp <- map["curp"]
        privacyPolicies <- map["avisosPrivacidad"]
    }
}

/// Privacy Policy business line and acceptance by the user
public class PrivacyPolicy: Mappable {
    /// Business data
    public var businessLine: ValueID?
    /// Acceptance date of the privacy policy
    public var acceptanceDate: String?
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        businessLine <- map["lineaNegocio"]
        acceptanceDate <- map["fechaAceptacion"]
    }
}
