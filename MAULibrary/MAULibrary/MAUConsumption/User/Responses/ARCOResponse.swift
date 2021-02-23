//
//  ARCOResponse.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 15/02/21.
//

import Foundation
import ObjectMapper

/// Object mapper for the ARCO response
class ARCOResponse: Mappable {
    /// Client's  CURP
    var curp: String?
    /// String that container "SI" o "NO" if the client's has ARCO rights
    var hasARCO: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        curp <- map["curp"]
        hasARCO <- map["arco"]
    }
}
