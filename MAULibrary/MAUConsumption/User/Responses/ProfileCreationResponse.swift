//
//  ProfileCreationResponse.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 12/02/21.
//

import Foundation
import ObjectMapper

/// Object mapper response for the profile creation service
public class ProfileCreationResponse: Mappable {
    /// ID of created user
    public var id: String?
    /// CURP of created user
    public var curp: String?
    /// Date when the data was updated
    public var updateDate: String?
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        id <- map["id"]
        curp <- map["curp"]
        updateDate <- map["fechaActualizacion"]
    }
}
