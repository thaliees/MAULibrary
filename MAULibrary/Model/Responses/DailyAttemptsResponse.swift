//
//  DailyAttemptsResponse.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 03/03/21.
//

import Foundation
import ObjectMapper

/**
 Object response for the daily attempts service
 */
class DailyAttemptsResponse: Mappable {
    /// Remaining attempts
    public var attempts: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        attempts <- map["restantes"]
    }
}
