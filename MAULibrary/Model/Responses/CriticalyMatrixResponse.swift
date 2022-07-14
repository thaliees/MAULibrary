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
public class CriticalityMatrixResponse: Mappable {
    /// Factor of the matrix (155 for email, 159 for facial and 154 for phone number)
    public var factor: ValueID?
    /// Origin of the factor
    public var origin: ValueID?
    /// Status of the factor (is 176 when is active)
    public var status: ValueID?
    /// Validity of the factor
    public var validity: Validity?
    /// Trys for the factor
    public var trys: Try?
    /// Process
    public var process: ValueID?
    /// Subprocess
    public var subprocess: ValueID?
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
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
public class Validity: Mappable {
    /// Autentication of validity
    public var autentication: Int?
    /// Enrollment of validity
    public var enrollment: Int?
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        autentication <- map["autenticacion"]
        enrollment <- map["enrolamiento"]
    }
}

/// Trys for the factor
public class Try: Mappable {
    /// Limit of trys
    public var limit: Int?
    /// Limit of daily trys
    public var dailyTrys: Int?
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        limit <- map["limite"]
        dailyTrys <- map["intentosDiarios"]
    }
}
