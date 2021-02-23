//
//  SMSEmailTokenResponse.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 26/01/21.
//

import Foundation
import ObjectMapper

/**
 Object response for the SMS and Email token service
 */
class SMSEmailTokenResponse: Mappable {
    /// Status of the token was sended
    var statusText: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        statusText <- map["statusText"]
    }
}
