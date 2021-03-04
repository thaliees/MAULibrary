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
    
    var method: HTTPMethod {
        switch self {
        case .getCriticalityMatrix, .getProfile, .getRemainingAttempts:
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
        }
    }
}
