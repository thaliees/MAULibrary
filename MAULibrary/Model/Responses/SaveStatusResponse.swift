//
//  SaveStatusResponse.swift
//  MAULibrary
//
//  Created by Thalia Aquino on 11/08/22.
//

import Foundation
import ObjectMapper

public class SaveSatusResponse: Mappable {
    public var curp: String?
    public var updateDate: String?
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        curp <- map["curp"]
        updateDate <- map["fechaActualizacion"]
    }
}
