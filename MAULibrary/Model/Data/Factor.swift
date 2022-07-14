//
//  Factor.swift
//  MAULibrary
//
//  Created by Sandra Guzman Bautista on 24/05/21.
//

import Foundation

public class Factor: Codable {
    public var id: String
    public var validity: Int
    public var uuid: String
    public var isValid: Bool
    
    public init(id: String, validity: Int, uuid: String?) {
        self.id = id
        self.validity = validity
        self.uuid =  uuid ?? ""
        self.isValid = uuid != nil ? true : false
    }
}
