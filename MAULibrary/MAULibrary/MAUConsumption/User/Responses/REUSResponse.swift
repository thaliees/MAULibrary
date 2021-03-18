//
//  REUSResponse.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 15/02/21.
//

import Foundation
import ObjectMapper

/// Object mapper for the REUS response
class REUSResponse: Mappable {
    /// String that contains "SI" or "NO" if the client's has REUS rights
    public var hasREUS: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        hasREUS <- map["reus"]
    }
}
