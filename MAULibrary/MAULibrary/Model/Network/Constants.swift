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
    #if DEBUG
    static let url = "https://api.dev.profuturo.mx/"
    #elseif QA
    static let url = "https://api.qa.profuturo.mx/"
    #else
    static let url = "https://api.profuturo.mx/"
    #endif
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

struct ServerErrors {
    static let sendTokenDailyTrysExceeded = "Se ha excedido el número de intentos diarios permitidos"
    static let timeExceededCreateNewToken = "Token no vigente"
    static let validateTokenDailyTrysExceeded = "Limite de intentos superados"
    static let validateExpiredToken = "Token no vigente"
    
}

enum NotificationObserverServices: String {
    case authenticationPassed = "AuthenticationPassed"
    case authenticationDenied = "AuthenticationDenied"
    case closeMAUPassedEnterToken = "CloseMAUPassedEnterToken"
    case closeMAUDeniedEnterToken = "CloseMAUDeniedEnterToken"
    case closeMAUSelectAuthentication = "CloseMAUSelectAuthentication"
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