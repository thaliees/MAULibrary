//
//  ConsumptionRouter.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 11/02/21.
//

import Foundation
import Alamofire

enum ConsumptionRouter: URLRequestConvertible {
    
    static var token: String?
    static var internalToken: String?
    
    //User WS
    case requestAccessToken
    case getProfileInformation(curp: String)
    case getCriticalityMatrix(processID: String, subprocessID: String, originID: String)
    case createUserProfile(curp: String, parameters: [String: Any])
    case getPrivacyPolicy(businessLine: String)
    case getPrivacyPolicyStatus(curp: String)
    case savePrivacyPolicyResponse(curp: String, parameters: [String: Any])
    case getARCO(parameters: [String: Any])
    case getREUS(parameters: [String: Any])
    
    //Token WS
    case validateToken(parameters: [String: Any])
    case sendSMSToken(parameters: [String: Any])
    case resendSMSToken(parameters: [String: Any])
    case sendEmailToken(parameters: [String: Any])
    case resendEmailToken(parameters: [String: Any])
    
    var method: HTTPMethod {
        switch self {
        case .requestAccessToken, .createUserProfile, .savePrivacyPolicyResponse, .getARCO, .getREUS, .sendSMSToken, .resendSMSToken, .sendEmailToken, .resendEmailToken, .validateToken:
            return .post
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .requestAccessToken:
            return MAUPaths.requestAccessToken
        case .getProfileInformation, .createUserProfile:
            return MAUPaths.getProfileInformation
        case .getCriticalityMatrix:
            return MAUPaths.getCriticalityMatrix
        case .getPrivacyPolicy:
            return MAUPaths.getPrivacyPolicy
        case .getPrivacyPolicyStatus:
            return MAUPaths.getPrivacyPolicyStatus
        case .savePrivacyPolicyResponse:
            return MAUPaths.savePrivacyPolicyResponse
        case .getARCO:
            return MAUPaths.getARCO
        case .getREUS:
            return MAUPaths.getREUS
        case .validateToken:
            return MAUPaths.validateToken
        case .sendSMSToken:
            return MAUPaths.sendSMSToken
        case .resendSMSToken:
            return MAUPaths.resendSMSToken
        case .sendEmailToken:
            return MAUPaths.sendEmailToken
        case .resendEmailToken:
            return MAUPaths.resendEmailToken
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        #if DEBUG
        let url = URL(string: Servers.developmentURL)!
        #else
        let url = URL(string: Servers.productionURL)!
        #endif
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = 60
        
        if let internalToken = ConsumptionRouter.internalToken {
            urlRequest.setValue("Basic \(internalToken)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        }
        
        if let token = ConsumptionRouter.token {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        }
        
        switch self {
        case .requestAccessToken:
            return try URLEncoding.default.encode(urlRequest, with: ["grant_type": "client_credentials"])
        case .getProfileInformation(let curp):
            urlRequest.url?.appendPathComponent("/\(curp)/perfil")
            return try URLEncoding.default.encode(urlRequest, with: nil)
        case .getCriticalityMatrix(let processID, let subprocessID, let originID):
            urlRequest.url?.appendPathComponent("/proceso/\(processID)/subprocesos/\(subprocessID)?origen=\(originID)")
            urlRequest.url = URL(string: (urlRequest.url?.absoluteString.removingPercentEncoding)!)
            return try URLEncoding.default.encode(urlRequest, with: nil)
        case .createUserProfile(let curp, parameters: let parameters):
            urlRequest.url?.appendPathComponent("/\(curp)/perfil/curp")
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .getPrivacyPolicy(let businessLine):
            urlRequest.url?.appendPathComponent("/\(businessLine)/aviso")
            return try URLEncoding.default.encode(urlRequest, with: nil)
        case .getPrivacyPolicyStatus(let curp):
            urlRequest.url?.appendPathComponent("/\(curp)/privacidad")
            return try URLEncoding.default.encode(urlRequest, with: nil)
        case .savePrivacyPolicyResponse(let curp, let parameters):
            urlRequest.url?.appendPathComponent("/\(curp)/privacidad")
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .getREUS(let parameters):
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .getARCO(let parameters):
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .validateToken(let parameters):
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .sendSMSToken(let parameters):
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .resendSMSToken(let parameters):
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .sendEmailToken(let parameters):
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .resendEmailToken(let parameters):
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
    }
}
