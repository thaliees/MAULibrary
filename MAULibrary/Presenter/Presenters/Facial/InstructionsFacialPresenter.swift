//
//  InstructionsFacialPresenter.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 04/03/21.
//

import Foundation
import Reachability
import Alamofire
import AlamofireObjectMapper

class InstructionsFacialPresenter {
    
    //MARK: - Properties
    weak private var instructionsFacialDelegate: InstructionsFacialDelegate?
    
    //MARK: - Init
    func setViewDelegate(instructionsFacialDelegate: InstructionsFacialDelegate?) {
        self.instructionsFacialDelegate = instructionsFacialDelegate
    }
    
    /**
     Check if the authentication method has attempts
     */
    func getFacialAttempts() {
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            Router.self.token = UserDefaults.standard.token
            
            let userInformation = UserDefaults.standard.userInformation
            
            Alamofire.request(
                Router.getRemainingAttempts(curp: userInformation.curp, processID: userInformation.processID, subprocessID: userInformation.subProcessID, originID: userInformation.originID, factorID: 159))
                .responseObject { (response: DataResponse<DailyAttemptsResponse>) in
                    switch response.result {
                    case .success(let attemptsResponse):
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            case 200:
                                let attempts = Int(attemptsResponse.attempts ?? "0") ?? 0
                                UserDefaults.standard.hasDailyAttemptsOfFacial = attempts < 1 ? false : true
                                
                                self.instructionsFacialDelegate?.showFacialAttempts()
                            default:
                                self.instructionsFacialDelegate?.showConnectionErrorMessage()
                            }
                        }
                    case .failure(_):
                        self.instructionsFacialDelegate?.showConnectionErrorMessage()
                    }
                }
        } else {
            self.instructionsFacialDelegate?.showConnectionErrorMessage()
        }
    }
    
    /**
     Register if method if successful
     */
    func saveValidityAuthentication() {
        //Set parameters
        let userInformation = UserDefaults.standard.userInformation
        let criticalityMatrix = UserDefaults.standard.arrayCriticalityMatrix
        let item = criticalityMatrix.filter {$0.id == TypesFactor.facial.rawValue}
        let parameters: [String: Any] = [
            "tiempoVigencia": item[0].validity,
            "origen": ["id": "\(userInformation.originID)"],
            "uuidSesionPadre": "\(userInformation.sessionID)"
        ]
        
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            Router.self.token = UserDefaults.standard.token
            
            Alamofire.request(Router.saveValidateAuthentication(curp: userInformation.curp,
                                                                factorID: TypesFactor.facial.rawValue,
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
                                        if item.id == TypesFactor.facial.rawValue {
                                            item.uuid = uuid
                                            isFound = true
                                        }
                                    }
                                    if !isFound {
                                        arrayFactors.append(Factor(id:TypesFactor.facial.rawValue,
                                                                   validity: item[0].validity,
                                                                   uuid: uuid))
                                    }
                                    UserDefaults.standard.arrayFactors = arrayFactors
                                    self.saveAuthentication(factorID: TypesFactor.facial.rawValue)
                                } else {
                                    self.instructionsFacialDelegate?.showConnectionErrorMessage()
                                }
                            default:
                                self.instructionsFacialDelegate?.showConnectionErrorMessage()
                            }
                        }
                    case .failure(_):
                        self.instructionsFacialDelegate?.showConnectionErrorMessage()
                    }
                }
        } else {
            self.instructionsFacialDelegate?.showConnectionErrorMessage()
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
                            self.instructionsFacialDelegate?.showAuthenticationSuccesful()
                        default:
                            self.instructionsFacialDelegate?.showConnectionErrorMessage()
                        }
                    }
                case .failure(_):
                    self.instructionsFacialDelegate?.showConnectionErrorMessage()
                }
            }
        } else {
            self.instructionsFacialDelegate?.showConnectionErrorMessage()
        }
    }
}

