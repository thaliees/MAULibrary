//
//  Router.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 04/12/20.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    static var token: String?
    static var internalToken: String?
    
    case generateToken
    case getCriticalityMatrix(processID: Int, subprocessID: Int, originID: Int)
    case getProfile(curp: String)
    case sendSMSToken(parameters: [String: Any])
    case resendSMSToken(parameters: [String: Any])
    case sendEmailToken(parameters: [String: Any])
    case resendEmailToken(parameters: [String: Any])
    case validateToken(parameters: [String: Any])
    case getRemainingAttempts(curp: String, processID: Int, subprocessID: Int, originID: Int, factorID: Int)
    case getValidityAuthentication(curp: String, factorID: String, uuid: String, sessionID: String)
    case previousAuthentication(curp: String, parameters: [String: Any])
    case registerAuthentication(curp: String, parameters: [String: Any])
    case saveValidateAuthentication(curp: String, factorID: String, parameters: [String: Any])
    case getValidateEditData(account: String, factor: String)
    case validateAuthentication(businessLine: String, parameters: [String:Any])
    case getMessages(parameters: [String: Any])
    
    var method: HTTPMethod {
        switch self {
        case .getCriticalityMatrix, .getProfile, .getRemainingAttempts, .getValidityAuthentication, .getValidateEditData:
            return .get
        default:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .generateToken:
            return Paths.generateToken
        case .getCriticalityMatrix:
            return Paths.criticalityMatrix
        case .getProfile:
            return Paths.profile
        case .sendSMSToken:
            return Paths.sendSMSToken
        case .resendSMSToken:
            return Paths.resendSMSToken
        case .sendEmailToken:
            return Paths.sendEmailToken
        case .resendEmailToken:
            return Paths.resendEmailToken
        case .validateToken:
            return Paths.validateToken
        case .getRemainingAttempts:
            return Paths.getRemainingAttempts
        case .getValidityAuthentication:
            return Paths.getValidateAuthentication
        case .previousAuthentication:
            return Paths.previousAuthentication
        case .registerAuthentication:
            return Paths.registerAuthentication
        case .saveValidateAuthentication:
            return Paths.saveValidateAuthentication
        case .getValidateEditData:
            return Paths.getValidateEditData
        case .validateAuthentication:
            return Paths.validateAuthentication
        case .getMessages:
            return Paths.getMessages
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: Servers.url)
        
        var urlRequest = URLRequest(url: url!.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = 60
        
        if let internalToken = Router.internalToken {
            urlRequest.setValue("Basic \(internalToken)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        }
        
        if let token = Router.token {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        }
        
        switch self {
        case .generateToken:
            return try URLEncoding.default.encode(urlRequest, with: ["grant_type": "client_credentials"])
        case .getCriticalityMatrix(processID: let processID, subprocessID: let subprocessID, originID: let originID):
            urlRequest.url?.appendPathComponent("/proceso/\(processID)/subprocesos/\(subprocessID)?origen=\(originID)")
            urlRequest.url = URL(string: (urlRequest.url?.absoluteString.removingPercentEncoding)!)
            return try URLEncoding.default.encode(urlRequest, with: nil)
        case .getProfile(curp: let curp):
            urlRequest.url?.appendPathComponent("/\(curp)/perfil")
            return try URLEncoding.default.encode(urlRequest, with: nil)
        case .sendSMSToken(let parameters):
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .resendSMSToken(let parameters):
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .sendEmailToken(let parameters):
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .resendEmailToken(let parameters):
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .validateToken(let parameters):
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .getRemainingAttempts(let curp, let processID, let subprocessID, let originID, let factorID):
            urlRequest.url?.appendPathComponent("/\(curp)/origen/\(originID)/proceso/\(processID)/subproceso/\(subprocessID)/factor-autenticacion/\(factorID)/intentos")
            urlRequest.url = URL(string: (urlRequest.url?.absoluteString.removingPercentEncoding)!)
            return try URLEncoding.default.encode(urlRequest, with: nil)
        case .getValidityAuthentication(let curp, let factorID, let uuid, let sessionID):
            urlRequest.url?.appendPathComponent("/\(curp)/factor/\(factorID)/consultar-vigencia?uuidRegistroFactor=\(uuid)&uuidSesionPadre=\(sessionID)")
            urlRequest.url = URL(string: (urlRequest.url?.absoluteString.removingPercentEncoding)!)
            return try URLEncoding.default.encode(urlRequest, with: nil)
        case .previousAuthentication(let curp, let parameters):
            urlRequest.url?.appendPathComponent("/\(curp)/autenticacionPrevia")
            urlRequest.url = URL(string: (urlRequest.url?.absoluteString.removingPercentEncoding)!)
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .registerAuthentication(let curp, let parameters):
            urlRequest.url?.appendPathComponent("/\(curp)/autenticacion")
            urlRequest.url = URL(string: (urlRequest.url?.absoluteString.removingPercentEncoding)!)
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .saveValidateAuthentication(let curp, let factorID, let parameters):
            urlRequest.url?.appendPathComponent("/\(curp)/factor/\(factorID)/registrar-vigencia")
            urlRequest.url = URL(string: (urlRequest.url?.absoluteString.removingPercentEncoding)!)
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .getValidateEditData(let account, let factor):
            urlRequest.url?.appendPathComponent("/\(account)/modificacionDatos?tipoDato=\(factor)")
            urlRequest.url = URL(string: (urlRequest.url?.absoluteString.removingPercentEncoding)!)
            return try URLEncoding.default.encode(urlRequest, with: nil)
        case .validateAuthentication(let businessLine, let parameters):
            urlRequest.url?.appendPathComponent("\(businessLine)/valida")
            urlRequest.url = URL(string: (urlRequest.url?.absoluteString.removingPercentEncoding)!)
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .getMessages(let parameters):
            urlRequest.url = URL(string: (urlRequest.url?.absoluteString.removingPercentEncoding)!)
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
    }
}
