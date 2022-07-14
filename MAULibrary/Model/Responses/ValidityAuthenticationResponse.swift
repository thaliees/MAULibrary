//
//  ValidityAuthenticationResponse.swift
//  MAULibrary
//
//  Created by Sandra Guzman Bautista on 08/07/21.
//

import Foundation
import ObjectMapper

/// Object mapper for the ValidateAuthentication response
class ValidityAuthenticationResponse: Mappable {
    /// If vigency is validity
    public var result: String?
    public var uuid: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        result <- map["resultadoVigencia"]
        uuid <- map["uuid"]
    }
}
