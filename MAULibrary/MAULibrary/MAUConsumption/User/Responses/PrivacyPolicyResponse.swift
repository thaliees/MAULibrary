//
//  PrivacyPolicyResponse.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 12/02/21.
//

import Foundation
import ObjectMapper

/// Object mapper response for the privacy policy service
class PrivacyPolicyResponse: Mappable {
    /// Business line of the required privacy policy
    var businessLine: ValueID?
    /// Required privacy policy
    var privacyPolicy: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        businessLine <- map["lineaNegocio"]
        privacyPolicy <- map["avisoPrivacidad"]
    }
}
