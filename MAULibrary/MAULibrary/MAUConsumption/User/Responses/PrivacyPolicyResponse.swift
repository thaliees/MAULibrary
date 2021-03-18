//
//  PrivacyPolicyResponse.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 12/02/21.
//

import Foundation
import ObjectMapper

/// Object mapper response for the privacy policy service
public class PrivacyPolicyResponse: Mappable {
    /// Business line of the required privacy policy
    public var businessLine: ValueID?
    /// Required privacy policy
    public var privacyPolicy: String?
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        businessLine <- map["lineaNegocio"]
        privacyPolicy <- map["avisoPrivacidad"]
    }
}
