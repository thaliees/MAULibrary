//
//  ValidateTokenResponse.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 26/01/21.
//

import Foundation
import ObjectMapper

/**
 Object response for the token validation service
 */
class ValidateTokenResponse: Mappable {
    /// Tells if the token is valid or not
    var valid: Bool?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        valid <- map["valido"]
    }
}
