//
//  MessagesResponse.swift
//  MAULibrary
//
//  Created by Thalia Aquino on 18/07/22.
//

import Foundation
import ObjectMapper

public class MessageResponse: Mappable {
    /// Object listaDiagnosticosOp enabled
    public var listMessages: Array<MessageDetail>?
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        listMessages <- map["listaMensajes"]
    }
}

/// Data of client facial biometrics
public class MessageDetail: Mappable {
    /// Process ID
    var processId: String?
    /// Technical Message
    var technicalMessage: String?
    /// User Message
    var userMessage: String?
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        processId <- map["idProcesar"]
        technicalMessage <- map["mensajeTecnico"]
        userMessage <- map["mensajeUsuario"]
    }
}
