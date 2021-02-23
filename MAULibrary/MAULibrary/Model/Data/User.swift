//
//  User.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 18/01/21.
//

import Foundation

public class User: Codable {
    
    var name: String
    var lastName: String
    var mothersLastName: String
    var client: String
    var phoneNumber: String = ""
    var email: String = ""
    var account: String
    var curp: String
    var processID: String
    var subProcessID: String
    var originID: String
    
    init(name: String, lastName: String, mothersLastName: String, client: String, account: String, curp: String, processID: String, subProcessID: String, originID: String) {
        self.name = name
        self.lastName = lastName
        self.mothersLastName = mothersLastName
        self.client = client
        self.account = account
        self.curp = curp
        self.processID = processID
        self.subProcessID = subProcessID
        self.originID = originID
    }
    
}
