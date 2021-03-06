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
        
        //Set parameters
        let userInformation = UserDefaults.standard.userInformation
        let parameters: [String: Any] = [
            "curp": userInformation.curp,
            "proceso": ["id": "\(userInformation.processID)"],
            "subproceso": ["id": "\(userInformation.subProcessID)"],
            "factor": ["id": "154"],
            "origen": ["id": "\(userInformation.originID)"],
            "mensaje": ["celular": userInformation.phoneNumber, "mensaje": "", "claveAplicacion": "APPCLIENTE"]
        ]
        
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            Router.self.token = UserDefaults.standard.token
            
            Alamofire.request(Router.sendSMSToken(parameters: parameters)).responseObject { (response: DataResponse<SMSEmailTokenResponse>) in
                switch response.result {
                case .success(let sendSMSTokenResponse):
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 200:
                            self.enterTokenDelegate?.hideLoader()
                        case 404:
                            if sendSMSTokenResponse.errorMessage == ServerErrors.sendTokenDailyTrysExceeded {
                                self.enterTokenDelegate?.showLimitExceeded()
                            } else {
                                self.enterTokenDelegate?.showConnectionErrorMessage()
                            }
                        default:
                            self.enterTokenDelegate?.showConnectionErrorMessage()
                        }
                    }
                case .failure(_):
                    self.enterTokenDelegate?.showConnectionErrorMessage()
                }
            }
        } else {
            self.enterTokenDelegate?.showConnectionErrorMessage()
        }
    }
    
    /**
     Send the token to the users email
     */
    func sendEmailToken() {
        //Show loader
        enterTokenDelegate?.showLoader()
        
        //Set parameters
        let userInformation = UserDefaults.standard.userInformation
        let parameters: [String: Any] = [
            "curp": userInformation.curp,
            "proceso": ["id": "\(userInformation.processID)"],
            "subproceso": ["id": "\(userInformation.subProcessID)"],
            "factor": ["id": "155"],
            "origen": ["id": "\(userInformation.originID)"],
            "correo": [
                "encabezado": ["asunto": "Envío Token", "remitente": "no-responder@profuturo.com.mx", "destinatario": userInformation.email, "copia": "", "copiaOculta": ""],
                "mensaje": ["contenido": "", "tipoContenido": "text/html"]
            ]
        ]
        
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            Router.self.token = UserDefaults.standard.token
            
            Alamofire.request(Router.sendEmailToken(parameters: parameters)).responseObject { (response: DataResponse<SMSEmailTokenResponse>) in
                switch response.result {
                case .success(let sendEmailTokenResponse):
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 200:
                            self.enterTokenDelegate?.hideLoader()
                        case 404:
                            if sendEmailTokenResponse.errorMessage == ServerErrors.sendTokenDailyTrysExceeded {
                                self.enterTokenDelegate?.showLimitExceeded()
                            } else {
                                self.enterTokenDelegate?.showConnectionErrorMessage()
                            }
                        default:
                            self.enterTokenDelegate?.showConnectionErrorMessage()
                        }
                    }
                case .failure(_):
                    self.enterTokenDelegate?.showConnectionErrorMessage()
                }
            }
        } else {
            self.enterTokenDelegate?.showConnectionErrorMessage()
        }
    }
    
    /**
     Resend the token to the users phone number, when the token expires (the service return a 404), the sendSMSToken function is called to create a new one
     */
    func resendSMSToken() {
        //Show loader
        enterTokenDelegate?.showLoader()
        
        //Set parameters
        let userInformation = UserDefaults.standard.userInformation
        let parameters: [String: Any] = [
            "curp": userInformation.curp,
            "proceso": ["id": "\(userInformation.processID)"],
            "subproceso": ["id": "\(userInformation.subProcessID)"],
            "factor": ["id": "154"],
            "origen": ["id": "\(userInformation.originID)"],
            "mensaje": ["celular": userInformation.phoneNumber, "mensaje": "", "claveAplicacion": "APPCLIENTE"]
        ]
        
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            Router.self.token = UserDefaults.standard.token
            
            Alamofire.request(Router.resendSMSToken(parameters: parameters)).responseObject { (response: DataResponse<SMSEmailTokenResponse>) in
                switch response.result {
                case .success(let resendSMSTokenResponse):
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 200:
                            self.enterTokenDelegate?.hideLoader()
                        case 404:
                            if resendSMSTokenResponse.errorMessage == ServerErrors.timeExceededCreateNewToken {
                                self.sendSMSToken()
                                
                            } else {
                                self.enterTokenDelegate?.showConnectionErrorMessage()
                            }
                        default:
                            self.enterTokenDelegate?.showConnectionErrorMessage()
                        }
                    }
                case .failure(_):
                    self.enterTokenDelegate?.showConnectionErrorMessage()
                }
            }
        } else {
            self.enterTokenDelegate?.showConnectionErrorMessage()
        }
    }
    
    /**
     Resend the token to the users email, when the token expires (the service return a 404), the sendEmailToken function is called to create a new one
     */
    func resendEmailToken() {
        //Show loader
        enterTokenDelegate?.showLoader()
        
        //Set parameters
        let userInformation = UserDefaults.standard.userInformation
        let parameters: [String: Any] = [
            "curp": userInformation.curp,
            "proceso": ["id": "\(userInformation.processID)"],
            "subproceso": ["id": "\(userInformation.subProcessID)"],
            "factor": ["id": "155"],
            "origen": ["id": "\(userInformation.originID)"],
            "correo": [
                "encabezado": ["asunto": "Envío Token", "remitente": "no-responder@profuturo.com.mx", "destinatario": userInformation.email, "copia": "", "copiaOculta": ""],
                "mensaje": ["contenido": "", "tipoContenido": "text/html"]
            ]
        ]
        
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            Router.self.token = UserDefaults.standard.token
            
            Alamofire.request(Router.resendEmailToken(parameters: parameters)).responseObject { (response: DataResponse<SMSEmailTokenResponse>) in
                switch response.result {
                case .success(let resendEmailTokenResponse):
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 200:
                            self.enterTokenDelegate?.hideLoader()
                        case 404:
                            if resendEmailTokenResponse.errorMessage == ServerErrors.timeExceededCreateNewToken {
                                self.sendEmailToken()
                            } else {
                                self.enterTokenDelegate?.showConnectionErrorMessage()
                            }
                        default:
                            self.enterTokenDelegate?.showConnectionErrorMessage()
                        }
                    }
                case .failure(_):
                    self.enterTokenDelegate?.showConnectionErrorMessage()
                }
            }
        } else {
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
        
        //Set parameters
        let userInformation = UserDefaults.standard.userInformation
        let parameters: [String: Any] = [
            "curp": userInformation.curp,
            "token": otpCode,
            "proceso": ["id": "\(userInformation.processID)"],
            "subproceso": ["id": "\(userInformation.subProcessID)"],
            "origen": ["id": "\(userInformation.originID)"],
            "factor": ["id": isEmail ? TypesFactor.email.rawValue : TypesFactor.phone.rawValue]
        ]
        
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            Router.self.token = UserDefaults.standard.token
            
            Alamofire.request(Router.validateToken(parameters: parameters)).responseObject { (response: DataResponse<ValidateTokenResponse>) in
                switch response.result {
                case .success(let validationResponse):
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 200:
                            if validationResponse.valid ?? false {
                                self.saveValidityAuthentication(factor: isEmail ? TypesFactor.email : TypesFactor.phone )
                            } else {
                                self.enterTokenDelegate?.showAuthenticationError()
                            }
                        case 404:
                            if validationResponse.limitExceeded == ServerErrors.validateTokenDailyTrysExceeded {
                                self.enterTokenDelegate?.showLimitExceeded()
                            } else if validationResponse.limitExceeded == ServerErrors.validateExpiredToken {
                                self.enterTokenDelegate?.showAuthenticationError()
                            } else {
                                self.enterTokenDelegate?.showConnectionErrorMessage()
                            }
                        default:
                            self.enterTokenDelegate?.showConnectionErrorMessage()
                        }
                    }
                case .failure(_):
                    self.enterTokenDelegate?.showConnectionErrorMessage()
                }
            }
        } else {
            self.enterTokenDelegate?.showConnectionErrorMessage()
        }
    }
    
    /**
     Register if method if successful
     */
    func saveValidityAuthentication(factor: TypesFactor) {
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            Router.self.token = UserDefaults.standard.token
            //Set parameters
            let userInformation = UserDefaults.standard.userInformation
            let criticalityMatrix = UserDefaults.standard.arrayCriticalityMatrix
            let item = criticalityMatrix.filter {$0.id == factor.rawValue}
            let parameters: [String: Any] = [
                "tiempoVigencia": item[0].validity,
                "origen": ["id": "\(userInformation.originID)"],
                "uuidSesionPadre": "\(userInformation.sessionID)"
            ]
            
            Alamofire.request(Router.saveValidateAuthentication(curp: userInformation.curp,
                                                                factorID: factor.rawValue,
                                                                parameters: parameters))
                .responseObject { (response: DataResponse<ValidityAuthenticationResponse>) in
                    switch response.result {
                    case .success(let validationResponse):
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            case 200:
                                if let uuid = validationResponse.uuid {
                                    var arrayFactors = UserDefaults.standard.arrayFactors
                                    var isFound = false
                                    for item in arrayFactors {
                                        if item.id == factor.rawValue {
                                            item.uuid = uuid
                                            isFound = true
                                        }
                                    }
                                    if !isFound {
                                        arrayFactors.append(Factor(id:factor.rawValue,
                                                                   validity: item[0].validity,
                                                                   uuid: uuid))
                                    }
                                    UserDefaults.standard.arrayFactors = arrayFactors
                                    self.saveAuthentication(factorID: factor.rawValue)
                                } else {
                                    self.enterTokenDelegate?.showConnectionErrorMessage()
                                }
                            default:
                                self.enterTokenDelegate?.showConnectionErrorMessage()
                            }
                        }
                    case .failure(_):
                        self.enterTokenDelegate?.showConnectionErrorMessage()
                    }
                }
        } else {
            self.enterTokenDelegate?.showConnectionErrorMessage()
        }
    }
    
    /**
     Register if method if successful
     */
    func saveAuthentication(factorID : String) {
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            Router.self.token = UserDefaults.standard.token
            let userInformation = UserDefaults.standard.userInformation
            let parameters: [String: Any] = [
                "proceso": ["id": "\(userInformation.processID)"],
                "subproceso": ["id": "\(userInformation.subProcessID)"],
                "origen": ["id": "\(userInformation.originID)"],
                "factor": ["id": "\(factorID)"],
                "estatus": ["id": "112"],
                "tipo": ["id": "126"]
            ]
            Alamofire.request(Router.registerAuthentication(curp: userInformation.curp, parameters: parameters))
                .responseObject { (response: DataResponse<ValueID>) in
                switch response.result {
                case .success(_):
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 200:
                            self.enterTokenDelegate?.showAuthenticationSuccesful()
                        default:
                            self.enterTokenDelegate?.showConnectionErrorMessage()
                        }
                    }
                case .failure(_):
                    self.enterTokenDelegate?.showConnectionErrorMessage()
                }
            }
        } else {
            self.enterTokenDelegate?.showConnectionErrorMessage()
        }
    }
}

