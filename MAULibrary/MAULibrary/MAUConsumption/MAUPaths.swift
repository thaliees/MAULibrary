//
//  MAUPaths.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 11/02/21.
//

import Foundation

struct MAUPaths {
    //User WS
    static let requestAccessToken = "oauth2/token"
    static let getProfileInformation = "mau/1/gu/usuarios"
    static let getCriticalityMatrix = "mau/1/ga/criticidad"
    static let getPrivacyPolicy = "mau/1/gp/privacidad"
    static let getPrivacyPolicyStatus = "mau/1/gp/usuarios"
    static let savePrivacyPolicyResponse = "mau/1/gp/usuarios"
    static let getARCO = "grupo/1/derechos/curps/derechos-arco"
    static let getREUS = "grupo/1/derechos/curps/derechos-reus"
    
    //Token WS
    static let validateToken = "mau/1/gt/token/validar"
    static let sendSMSToken = "mau/1/gt/token/celular/enviar"
    static let resendSMSToken = "mau/1/gt/token/celular/reenviar"
    static let sendEmailToken = "mau/1/gt/token/correo/enviar"
    static let resendEmailToken = "mau/1/gt/token/correo/reenviar"
}
