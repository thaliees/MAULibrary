//
//  SavePrivacyPolicyResponse.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 12/02/21.
//

import Foundation
import ObjectMapper

/// Object mapper response for the privacy policy saving service
public class SavePrivacyPolicyResponse: Mappable {
    /// ID of the stored data
    public var id: String?
    /// Client's CURP
    public var curp: String?
    /// Business line of the privacy policy
    public var businessLine: ValueID?
    /// Date when the privacy policy was accepted
    public var updateDate: String?
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        id <- map["id"]
        curp <- map["curp"]
        businessLine <- map["lineaNegocio"]
        updateDate <- map["fechaActualizacion"]
    }
}

