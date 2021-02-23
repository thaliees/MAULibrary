//
//  CriticalityMatrixResponse.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 28/01/21.
//

import Foundation
import ObjectMapper

/**
 Object mapper response for Criticality matrix. The factors ID's are 159 (facial), 154 (cellphone) and 155 (email).
 */
class CriticalityMatrixResponse: Mappable {
    /// Factor of the matrix (155 for email, 159 for facial and 154 for phone number)
    var factor: ValueID?
    /// Origin of the factor
    var origin: ValueID?
    /// Status of the factor (is 176 when is active)
    var status: ValueID?
    /// Validity of the factor
    var validity: Validity?
    /// Trys for the factor
    var trys: Try?
    /// Process
    var process: ValueID?
    /// Subprocess
    var subprocess: ValueID?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        factor <- map["factor"]
        origin <- map["origen"]
        status <- map["estatus"]
        validity <- map["vigencia"]
        trys <- map["intentos"]
        process <- map["proceso"]
        subprocess <- map["subProceso"]
    }
}

/// Validity of the factor
class Validity: Mappable {
    /// Autentication of validity
    var autentication: Int?
    /// Enrollment of validity
    var enrollment: Int?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        autentication <- map["autenticacion"]
        enrollment <- map["enrolamiento"]
    }
}

/// Trys for the factor
class Try: Mappable {
    /// Limit of trys
    var limit: Int?
    /// Limit of daily trys
    var dailyTrys: Int?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        limit <- map["limite"]
        dailyTrys <- map["intentosDiarios"]
    }
}
