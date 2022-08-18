//
//  EnrollOrValidationResponse.swift
//  MAULibrary
//
//  Created by Thalia Aquino on 03/08/22.
//

import Foundation
import ObjectMapper

public class EnrollOrValidationResponse: Mappable {
    /// Object EnrollOrValidation enabled
    public var curp: String?
    public var token: String?
    public var resultOp: String?
    public var listOp: Array<String>?
    public var resultValidation: String?
    public var qualification: String?
    public var enroll: String?
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        curp <- map["curp"]
        token <- map["token"]
        resultOp <- map["resultadoOperacion"]
        listOp <- map["listaDiagnosticosOp"]
        resultValidation <- map["resultadoValidacion"]
        qualification <- map["calificacion"]
        enroll <- map["enrolado"]
    }
}
