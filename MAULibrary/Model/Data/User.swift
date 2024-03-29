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
    public var sessionID: String
    public var cveEntity: Int
    public var userType: String
    
    public var businessLine: String
    public var cveOrigin: String
    public var cveOperation: String
    
    public init(name: String, lastName: String, mothersLastName: String, client: String, account: String, curp: String, processID: Int, subProcessID: Int, originID: Int, sessionID: String, cveEntity: Int, userType: String, businessLine: String, cveOrigin: String, cveOperation: String) {
        self.name = name
        self.lastName = lastName
        self.mothersLastName = mothersLastName
        self.client = client
        self.account = account
        self.curp = curp
        self.processID = processID
        self.subProcessID = subProcessID
        self.originID = originID
        self.sessionID = sessionID
        self.cveEntity = cveEntity
        self.userType = userType
        self.businessLine = businessLine
        self.cveOrigin = cveOrigin
        self.cveOperation = cveOperation
    }
    
}
