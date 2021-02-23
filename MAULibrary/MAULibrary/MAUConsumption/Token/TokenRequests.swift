//
//  TokenRequests.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 15/02/21.
//

import Foundation
import Reachability
import Alamofire
import AlamofireObjectMapper

class TokenRequests {
    
    /**
     Sends a new token to the client's phone number
     - Parameter curp: Client's CURP
     - Parameter processID: ID of the process
     - Parameter subprocessID: ID of the subprocess
     - Parameter factorID: ID of the factor
     - Parameter originID: ID of the origin
     - Parameter phoneNumber: Client's phone number
     - Parameter tokenSended: Tells if the token was sended to the client
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection, 1 if is a successful response and 3 if the user exceeded daily trys.
     */
    func sendSMSToken(curp: String, processID: String, subprocessID: String, factorID: String, originID: String, phoneNumber: String, completion: @escaping (_ tokenSended: Bool, _ responseCode: Int) -> ()) {
        //Check internet connection
        let reachability = try! Reachability()
        
        #if DEBUG
        print(reachability.connection)
        #endif
        
        //Consumption
        reachability.whenReachable = { _ in
            
            if reachability.connection == .cellular || reachability.connection == .wifi {
                ConsumptionRouter.self.token = UserDefaults.standard.mauToken
                
                let parameters: [String: Any] = [
                    "curp": curp,
                    "proceso": ["id": processID],
                    "subproceso": ["id": subprocessID],
                    "factor": ["id": factorID],
                    "origen": ["id": originID],
                    "mensaje": ["celular": phoneNumber, "mensaje": "", "claveAplicacion": "APPCLIENTE"]
                ]
                
                Alamofire.request(ConsumptionRouter.sendSMSToken(parameters: parameters)).responseObject { (response: DataResponse<SMSEmailTokenResponse>) in
                    switch response.result {
                    case .success(let sendTokenResponse):
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            case 200:
                                if sendTokenResponse.statusText == "OK" {
                                    completion(true, 1)
                                } else {
                                    completion(false, -1)
                                }
                            case 404:
                                completion(false, 3)
                            default:
                                completion(false, -1)
                            }
                        }
                    case .failure(let error):
                        #if DEBUG
                        print(error)
                        #endif
                        completion(false, -1)
                    }
                }
            }
        }
        reachability.whenUnreachable = { _ in
            completion(false, 0)
        }
    }
    
    /**
     Resends the token to the client's phone number
     - Parameter curp: Client's CURP
     - Parameter processID: ID of the process
     - Parameter subprocessID: ID of the subprocess
     - Parameter factorID: ID of the factor
     - Parameter originID: ID of the origin
     - Parameter phoneNumber: Client's phone number
     - Parameter tokenSended: Tells if the token was sended to the client
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection, 1 if is a successful response and 2 if the token expired and you need to create a new one.
     */
    func resendSMSToken(curp: String, processID: String, subprocessID: String, factorID: String, originID: String, phoneNumber: String, completion: @escaping (_ tokenSended: Bool, _ responseCode: Int) -> ()) {
        //Check internet connection
        let reachability = try! Reachability()
        
        #if DEBUG
        print(reachability.connection)
        #endif
        
        //Consumption
        reachability.whenReachable = { _ in
            
            if reachability.connection == .cellular || reachability.connection == .wifi {
                ConsumptionRouter.self.token = UserDefaults.standard.mauToken
                
                let parameters: [String: Any] = [
                    "curp": curp,
                    "proceso": ["id": processID],
                    "subproceso": ["id": subprocessID],
                    "factor": ["id": factorID],
                    "origen": ["id": originID],
                    "mensaje": ["celular": phoneNumber, "mensaje": "", "claveAplicacion": "APPCLIENTE"]
                ]
                
                Alamofire.request(ConsumptionRouter.resendSMSToken(parameters: parameters)).responseObject { (response: DataResponse<SMSEmailTokenResponse>) in
                    switch response.result {
                    case .success(let sendTokenResponse):
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            case 200:
                                if sendTokenResponse.statusText == "OK" {
                                    completion(true, 1)
                                } else {
                                    completion(false, -1)
                                }
                            case 404:
                                completion(false, 2)
                            default:
                                completion(false, -1)
                            }
                        }
                    case .failure(let error):
                        #if DEBUG
                        print(error)
                        #endif
                        completion(false, -1)
                    }
                }
            }
        }
        reachability.whenUnreachable = { _ in
            completion(false, 0)
        }
    }
    
    /**
     Sends a new token to the client's email
     - Parameter curp: Client's CURP
     - Parameter processID: ID of the process
     - Parameter subprocessID: ID of the subprocess
     - Parameter factorID: ID of the factor
     - Parameter originID: ID of the origin
     - Parameter clientEmail: Client's email
     - Parameter tokenSended: Tells if the token was sended to the client
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection, 1 if is a successful response and 3 if the user exceeded daily trys.
     */
    func sendEmailToken(curp: String, processID: String, subprocessID: String, factorID: String, originID: String, clientEmail: String, completion: @escaping (_ tokenSended: Bool, _ responseCode: Int) -> ()) {
        //Check internet connection
        let reachability = try! Reachability()
        
        #if DEBUG
        print(reachability.connection)
        #endif
        
        //Consumption
        reachability.whenReachable = { _ in
            
            if reachability.connection == .cellular || reachability.connection == .wifi {
                ConsumptionRouter.self.token = UserDefaults.standard.mauToken
                
                let parameters: [String: Any] = [
                    "curp": curp,
                    "proceso": ["id": processID],
                    "subproceso": ["id": subprocessID],
                    "factor": ["id": factorID],
                    "origen": ["id": originID],
                    "correo": [
                        "encabezado": ["asunto": "Token Profuturo", "remitente": "no-responder@profuturo.com.mx", "destinatario": clientEmail, "copia": "", "copiaOculta": ""],
                        "mensaje": ["contenido": "", "tipoContenido": "text/html"]
                    ]
                ]
                
                Alamofire.request(ConsumptionRouter.sendEmailToken(parameters: parameters)).responseObject { (response: DataResponse<SMSEmailTokenResponse>) in
                    switch response.result {
                    case .success(let sendTokenResponse):
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            case 200:
                                if sendTokenResponse.statusText == "OK" {
                                    completion(true, 1)
                                } else {
                                    completion(false, -1)
                                }
                            case 404:
                                completion(false, 3)
                            default:
                                completion(false, -1)
                            }
                        }
                    case .failure(let error):
                        #if DEBUG
                        print(error)
                        #endif
                        completion(false, -1)
                    }
                }
            }
        }
        reachability.whenUnreachable = { _ in
            completion(false, 0)
        }
    }
    
    /**
     Resends the token to the client's email
     - Parameter curp: Client's CURP
     - Parameter processID: ID of the process
     - Parameter subprocessID: ID of the subprocess
     - Parameter factorID: ID of the factor
     - Parameter originID: ID of the origin
     - Parameter clientEmail: Client's email
     - Parameter tokenSended: Tells if the token was sended to the client
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection, 1 if is a successful response and 2 if the token expired and you need to create a new one.
     */
    func resendEmailToken(curp: String, processID: String, subprocessID: String, factorID: String, originID: String, clientEmail: String, completion: @escaping (_ tokenSended: Bool, _ responseCode: Int) -> ()) {
        //Check internet connection
        let reachability = try! Reachability()
        
        #if DEBUG
        print(reachability.connection)
        #endif
        
        //Consumption
        reachability.whenReachable = { _ in
            
            if reachability.connection == .cellular || reachability.connection == .wifi {
                ConsumptionRouter.self.token = UserDefaults.standard.mauToken
                
                let parameters: [String: Any] = [
                    "curp": curp,
                    "proceso": ["id": processID],
                    "subproceso": ["id": subprocessID],
                    "factor": ["id": factorID],
                    "origen": ["id": originID],
                    "correo": [
                        "encabezado": ["asunto": "Token Profuturo", "remitente": "no-responder@profuturo.com.mx", "destinatario": clientEmail, "copia": "", "copiaOculta": ""],
                        "mensaje": ["contenido": "", "tipoContenido": "text/html"]
                    ]
                ]
                
                Alamofire.request(ConsumptionRouter.sendEmailToken(parameters: parameters)).responseObject { (response: DataResponse<SMSEmailTokenResponse>) in
                    switch response.result {
                    case .success(let sendTokenResponse):
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            case 200:
                                if sendTokenResponse.statusText == "OK" {
                                    completion(true, 1)
                                } else {
                                    completion(false, -1)
                                }
                            case 404:
                                completion(false, 2)
                            default:
                                completion(false, -1)
                            }
                        }
                    case .failure(let error):
                        #if DEBUG
                        print(error)
                        #endif
                        completion(false, -1)
                    }
                }
            }
        }
        reachability.whenUnreachable = { _ in
            completion(false, 0)
        }
    }
    
    /**
     Sends a new token to the client's email
     - Parameter curp: Client's CURP
     - Parameter processID: ID of the process
     - Parameter subprocessID: ID of the subprocess
     - Parameter factorID: ID of the factor
     - Parameter originID: ID of the origin
     - Parameter token: Token to validate
     - Parameter isValid: Tells if the token is valid with the one stored in the server
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection and 1 if is a successful response.
     */
    func validateToken(curp: String, processID: String, subprocessID: String, factorID: String, originID: String, token: String, completion: @escaping (_ isValid: Bool, _ responseCode: Int) -> ()) {
        //Check internet connection
        let reachability = try! Reachability()
        
        #if DEBUG
        print(reachability.connection)
        #endif
        
        //Consumption
        reachability.whenReachable = { _ in
            
            if reachability.connection == .cellular || reachability.connection == .wifi {
                ConsumptionRouter.self.token = UserDefaults.standard.mauToken
                
                //Set parameters
                let parameters: [String: Any] = [
                    "curp": curp,
                    "token": token,
                    "proceso": ["id": processID],
                    "subproceso": ["id": subprocessID],
                    "origen": ["id": originID],
                    "factor": ["id": factorID]
                ]
                
                Alamofire.request(ConsumptionRouter.validateToken(parameters: parameters)).responseObject { (response: DataResponse<ValidateTokenResponse>) in
                    switch response.result {
                    case .success(let validationResponse):
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            case 200:
                                if validationResponse.valid ?? false {
                                    completion(true, 1)
                                } else {
                                    completion(false, 1)
                                }
                            default:
                                completion(false, -1)
                            }
                        }
                    case .failure(let error):
                        #if DEBUG
                        print(error)
                        #endif
                        completion(false, -1)
                    }
                }
            }
        }
        reachability.whenUnreachable = { _ in
            completion(false, 0)
        }
    }
}
