//
//  IdentificatorResponse.swift
//  MAULibrary
//
//  Created by Sandra Guzman Bautista on 27/05/21.
//

import Foundation
import ObjectMapper

/// Object mapper for the Session ID response
class IdentificatorResponse: Mappable {
    /// User session id
    public var id: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["identificador"]
    }
}
