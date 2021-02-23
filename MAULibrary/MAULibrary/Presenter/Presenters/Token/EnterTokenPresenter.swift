//
//  EnterTokenPresenter.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 26/01/21.
//

import Foundation
import UIKit
import Reachability
import Alamofire

class EnterTokenPresenter {
    
    //MARK: - Properties
    weak private var enterTokenDelegate: EnterTokenDelegate?
    
    //MARK: - Init
    func setViewDelegate(enterTokenDelegate: EnterTokenDelegate?) {
        self.enterTokenDelegate = enterTokenDelegate
    }
    
    //MARK: - Logic
    /**
     Send the token to the users phone number
     */
    func sendSMSToken() {
        //Show loader
        enterTokenDelegate?.showLoader()
        
        //Check internet connection
        let reachability = try! Reachability()
        
        #if DEBUG
        print(reachability.connection)
        #endif
        
        //Set parameters
        let userInformation = UserDefaults.standard.userInformation
        let parameters: [String: Any] = [
            "curp": userInformation.curp,
            "proceso": ["id": userInformation.processID],
            "subproceso": ["id": userInformation.subProcessID],
            "factor": "154",
            "origen": ["id": userInformation.originID],
            "mensaje": ["celular": userInformation.phoneNumber, "mensaje": "", "claveAplicacion": "APPCLIENTE"]
        ]
        
        //Consumption
        reachability.whenReachable = { _ in
            
            if reachability.connection == .cellular || reachability.connection == .wifi {
                Router.self.token = UserDefaults.standard.token
                
                Alamofire.request(Router.sendSMSToken(parameters: parameters)).responseObject { (response: DataResponse<SMSEmailTokenResponse>) in
                    switch response.result {
                    case .success(_):
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            case 200:
                                self.enterTokenDelegate?.hideLoader()
                            default:
                                self.enterTokenDelegate?.showConnectionErrorMessage()
                            }
                        }
                    case .failure(let error):
                        #if DEBUG
                        print(error)
                        #endif
                        self.enterTokenDelegate?.showConnectionErrorMessage()
                    }
                }
            }
        }
        reachability.whenUnreachable = { _ in
            self.enterTokenDelegate?.showConnectionErrorMessage()
        }
    }
    
    /**
     Send the token to the users email
     */
    func sendEmailToken() {
        //Show loader
        enterTokenDelegate?.showLoader()
        
        //Check internet connection
        let reachability = try! Reachability()
        
        #if DEBUG
        print(reachability.connection)
        #endif
        
        //Set parameters
        let userInformation = UserDefaults.standard.userInformation
        let parameters: [String: Any] = [
            "curp": userInformation.curp,
            "proceso": ["id": userInformation.processID],
            "subproceso": ["id": userInformation.subProcessID],
            "factor": "155",
            "origen": ["id": userInformation.originID],
            "correo": [
                "encabezado": ["asunto": "Envío Token", "remitente": "no-responder@profuturo.com.mx", "destinatario": userInformation.email, "copia": "", "copiaOculta": ""],
                "mensaje": ["contenido": "", "tipoContenido": "text/html"]
            ]
        ]
        
        //Consumption
        reachability.whenReachable = { _ in
            
            if reachability.connection == .cellular || reachability.connection == .wifi {
                Router.self.token = UserDefaults.standard.token
                
                Alamofire.request(Router.sendEmailToken(parameters: parameters)).responseObject { (response: DataResponse<SMSEmailTokenResponse>) in
                    switch response.result {
                    case .success(_):
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            case 200:
                                self.enterTokenDelegate?.hideLoader()
                            default:
                                self.enterTokenDelegate?.showConnectionErrorMessage()
                            }
                        }
                    case .failure(let error):
                        #if DEBUG
                        print(error)
                        #endif
                        self.enterTokenDelegate?.showConnectionErrorMessage()
                    }
                }
            }
        }
        reachability.whenUnreachable = { _ in
            self.enterTokenDelegate?.showConnectionErrorMessage()
        }
    }
    
    /**
     Resend the token to the users phone number, when the token expires (the service return a 404), the sendSMSToken function is called to create a new one
     */
    func resendSMSToken() {
        //Show loader
        enterTokenDelegate?.showLoader()
        
        //Check internet connection
        let reachability = try! Reachability()
        
        #if DEBUG
        print(reachability.connection)
        #endif
        
        //Set parameters
        let userInformation = UserDefaults.standard.userInformation
        let parameters: [String: Any] = [
            "curp": userInformation.curp,
            "proceso": ["id": userInformation.processID],
            "subproceso": ["id": userInformation.subProcessID],
            "factor": "154",
            "origen": ["id": userInformation.originID],
            "mensaje": ["celular": userInformation.phoneNumber, "mensaje": "", "claveAplicacion": "APPCLIENTE"]
        ]
        
        //Consumption
        reachability.whenReachable = { _ in
            
            if reachability.connection == .cellular || reachability.connection == .wifi {
                Router.self.token = UserDefaults.standard.token
                
                Alamofire.request(Router.resendSMSToken(parameters: parameters)).responseObject { (response: DataResponse<SMSEmailTokenResponse>) in
                    switch response.result {
                    case .success(_):
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            case 200:
                                self.enterTokenDelegate?.hideLoader()
                            case 404:
                                self.sendSMSToken()
                            default:
                                self.enterTokenDelegate?.showConnectionErrorMessage()
                            }
                        }
                    case .failure(let error):
                        #if DEBUG
                        print(error)
                        #endif
                        self.enterTokenDelegate?.showConnectionErrorMessage()
                    }
                }
            }
        }
        reachability.whenUnreachable = { _ in
            self.enterTokenDelegate?.showConnectionErrorMessage()
        }
    }
    
    /**
     Resend the token to the users email, when the token expires (the service return a 404), the sendEmailToken function is called to create a new one
     */
    func resendEmailToken() {
        //Show loader
        enterTokenDelegate?.showLoader()
        
        //Check internet connection
        let reachability = try! Reachability()
        
        #if DEBUG
        print(reachability.connection)
        #endif
        
        //Set parameters
        let userInformation = UserDefaults.standard.userInformation
        let parameters: [String: Any] = [
            "curp": userInformation.curp,
            "proceso": ["id": userInformation.processID],
            "subproceso": ["id": userInformation.subProcessID],
            "factor": "155",
            "origen": ["id": userInformation.originID],
            "correo": [
                "encabezado": ["asunto": "Envío Token", "remitente": "no-responder@profuturo.com.mx", "destinatario": userInformation.email, "copia": "", "copiaOculta": ""],
                "mensaje": ["contenido": "", "tipoContenido": "text/html"]
            ]
        ]
        
        //Consumption
        reachability.whenReachable = { _ in
            
            if reachability.connection == .cellular || reachability.connection == .wifi {
                Router.self.token = UserDefaults.standard.token
                
                Alamofire.request(Router.resendEmailToken(parameters: parameters)).responseObject { (response: DataResponse<SMSEmailTokenResponse>) in
                    switch response.result {
                    case .success(_):
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            case 200:
                                self.enterTokenDelegate?.hideLoader()
                            case 404:
                                self.sendEmailToken()
                            default:
                                self.enterTokenDelegate?.showConnectionErrorMessage()
                            }
                        }
                    case .failure(let error):
                        #if DEBUG
                        print(error)
                        #endif
                        self.enterTokenDelegate?.showConnectionErrorMessage()
                    }
                }
            }
        }
        reachability.whenUnreachable = { _ in
            self.enterTokenDelegate?.showConnectionErrorMessage()
        }
    }
    
    /**
     Validates if a token is correct or wrong
     
     - Parameter otpCode: OTP entered by the user
     */
    func validateToken(otpCode: String, isEmail: Bool) {
        //Show loader
        enterTokenDelegate?.showLoader()
        
        //Check internet connection
        let reachability = try! Reachability()
        
        #if DEBUG
        print(reachability.connection)
        #endif
        
        //Set parameters
        let userInformation = UserDefaults.standard.userInformation
        let parameters: [String: Any] = [
            "curp": userInformation.curp,
            "token": otpCode,
            "proceso": ["id": userInformation.processID],
            "subproceso": ["id": userInformation.subProcessID],
            "origen": ["id": userInformation.originID],
            "factor": isEmail ? "155" : "154"
        ]
        
        //Consumption
        reachability.whenReachable = { _ in
            
            if reachability.connection == .cellular || reachability.connection == .wifi {
                Router.self.token = UserDefaults.standard.token
                
                Alamofire.request(Router.validateToken(parameters: parameters)).responseObject { (response: DataResponse<ValidateTokenResponse>) in
                    switch response.result {
                    case .success(let validationResponse):
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            case 200:
                                if validationResponse.valid ?? false {
                                    self.enterTokenDelegate?.showAuthenticationSuccesful()
                                } else {
                                    self.enterTokenDelegate?.showAuthenticationError()
                                }
                            default:
                                self.enterTokenDelegate?.showConnectionErrorMessage()
                            }
                        }
                    case .failure(let error):
                        #if DEBUG
                        print(error)
                        #endif
                        self.enterTokenDelegate?.showConnectionErrorMessage()
                    }
                }
            }
        }
        reachability.whenUnreachable = { _ in
            self.enterTokenDelegate?.showConnectionErrorMessage()
        }
    }
}
