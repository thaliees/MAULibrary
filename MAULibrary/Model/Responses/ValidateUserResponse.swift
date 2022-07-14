//
//  ValidateUserResponse.swift
//  MAULibrary
//
//  Created by Thalia Aquino on 01/07/22.
//

import Foundation
import ObjectMapper

public class ValidateUserResponse: Mappable {
    /// Client CURP data
    public var curp: String?
    /// Client cveEntidad data
    public var cveEntity: String?
    /// Client cveOperacion data
    public var cveOperation: String?
    /// Client  cveOrigen data
    public var cveOrigin: String?
    /// Client enrolamientoDactilar data
    public var enrollDactilar: String?
    /// Client enrolamientoFacial data
    public var enrollFacial: String?
    /// Object listaDiagnosticosOp enabled
    public var listDiagnosticsOp: Array<Any>?
    /// Client  resultadoOperacion data
    public var operationResult: String?
    /// Client tipoUsuario data
    public var usertype: String?
    /// Client token data
    public var token: String?
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        curp <- map["curp"]
        cveEntity <- map["cveEntidad"]
        cveOperation <- map["cveOperacion"]
        cveOrigin <- map["cveOrigen"]
        enrollDactilar <- map["enrolamientoDactilar"]
        enrollFacial <- map["enrolamientoFacial"]
        listDiagnosticsOp <- map["listaDiagnosticosOp"]
        operationResult <- map["resultadoOperacion"]
        usertype <- map["tipoUsuario"]
        token <- map["token"]
    }
}

/// Data of client facial biometrics
public class DiagnosticosOp: Mappable {
    /// Status of the facial biometrics
    var status: ValueID?
    /// Origin of the facial biometrics
    var origin: ValueID?
    /// Last update date of the facial biometrics
    var updateDate: String?
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        status <- map["estado"]
        origin <- map["origen"]
        updateDate <- map["fechaActualizacion"]
    }
}
