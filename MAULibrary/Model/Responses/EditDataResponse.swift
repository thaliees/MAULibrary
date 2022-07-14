//
//  EditDataResponse.swift
//  MAULibrary
//
//  Created by Sandra Guzman Bautista on 11/06/21.
//

import Foundation
import ObjectMapper

/// Object mapper response for the edit data creation service
public class EditDataResponse: Mappable {
    /// Object MD enabled
    public var md: Array<MDResponse>?
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        md <- map["solicitudesMDActivas"]
    }
}

/// Object mapper response for the edit data creation service
public class MDResponse : Mappable {
    /// Object MD enabled
    public var id: String?
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        id <- map["id"]
    }
}

