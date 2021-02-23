//
//  ProfileCreationResponse.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 12/02/21.
//

import Foundation
import ObjectMapper

/// Object mapper response for the profile creation service
class ProfileCreationResponse: Mappable {
    /// ID of created user
    var id: String?
    /// CURP of created user
    var curp: String?
    /// Date when the data was updated
    var updateDate: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        curp <- map["curp"]
        updateDate <- map["fechaActualizacion"]
    }
}
