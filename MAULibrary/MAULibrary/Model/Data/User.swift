//
//  User.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 18/01/21.
//

import Foundation

public class User: Codable {
    public var name: String
    public var lastName: String
    public var mothersLastName: String
    public var client: String
    public var phoneNumber: String = ""
    public var email: String = ""
    public var account: String
    public var curp: String
    public var processID: Int
    public var subProcessID: Int
    public var originID: Int
    
    public init(name: String, lastName: String, mothersLastName: String, client: String, account: String, curp: String, processID: Int, subProcessID: Int, originID: Int) {
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
