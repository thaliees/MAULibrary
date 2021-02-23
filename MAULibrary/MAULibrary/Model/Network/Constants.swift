//
//  Constants.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 30/11/20.
//

import Foundation
import Alamofire

private let userKey = "wtcMRv8koWtZl1cavOAi11a9O1dRRJQj"
private let userSecret = "hPxnoZvqPAa8r1NW"

struct Keys {
    static let tokenKey = "\(userKey):\(userSecret)".toBase64()
}

struct Servers {
    static let developmentURL = "https://api.dev.profuturo.mx/"
    static let productionURL = ""
}

struct Paths {
    static let generateToken = "oauth2/token"
    static let criticalityMatrix = "mau/1/ga/criticidad"
    static let profile = "mau/1/gu/usuarios"
    static let sendSMSToken = "mau/1/gt/token/celular/enviar"
    static let resendSMSToken = "mau/1/gt/token/celular/reenviar"
    static let sendEmailToken = "mau/1/gt/token/correo/enviar"
    static let resendEmailToken = "mau/1/gt/token/correo/reenviar"
    static let validateToken = "mau/1/gt/token/validar"
}

enum NotificationObserverServices: String {
    case closeMAU = "CloseMAU"
    case closeEnterToken = "CloseEnterToken"
    case tryAgainAuthentication = "TryAgainAuthentication"
}

/**
 Enum for headers for the WS petitions
 */
enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
}

/**
 Enum for the content type of the petition to the web services
 */
enum ContentType: String {
    case formEncoded = "application/x-www-form-urlencoded"
}
