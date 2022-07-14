//
//  TokenResponse.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 03/12/20.
//

import Foundation
import ObjectMapper

/**
 Object response for the access token service
 */
class TokenResponse: Mappable {
    /// Access token
    public var token: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        token <- map["access_token"]
    }
}
