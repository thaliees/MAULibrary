//
//  SelectAuthenticationMethodPresenter.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 05/01/21.
//

import Foundation
import Reachability
import Alamofire
import AlamofireObjectMapper

class SelectAuthenticationMethodPresenter {
    
    //MARK: - Properties
    weak private var selectAuthenticationMethodDelegate: SelectAuthenticationMethodDelegate?
    
    //MARK: - Init
    func setViewDelegate(selectAuthenticationMethodDelegate: SelectAuthenticationMethodDelegate?) {
        self.selectAuthenticationMethodDelegate = selectAuthenticationMethodDelegate
    }
    //MARK: - Logic Properties
    var arrayFactors: [Factor] = []
    var countArrayFactors = 0
    
    //MARK: - Logic
    /**
     Generates a new token to request petitions to the server
     */
    func generateToken() {
        print("MAU: generateToken")
        //Show loader
        selectAuthenticationMethodDelegate?.showLoader()
        
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            //Set internal developer token
            Router.self.internalToken = Keys.tokenKey
            Router.self.token = nil
            
            Alamofire.request(Router.generateToken).responseObject { (response: DataResponse<TokenResponse>) in
                switch response.result {
                case .success(let tokenResponse):
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 200:
                            UserDefaults.standard.token = tokenResponse.token!
                            
                            //Get criticality matrix to know what authentication methods can use the user
                            self.getCriticalityMatrix()
                            break
                        default:
                            self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                        }
                    }
                case .failure(_):
                    self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                }
            }
        } else {
            self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
        }
    }
    
    /**
     Consult the criticality matrix for processes and subprocesses
     */
    func getCriticalityMatrix() {
        print("MAU: getCriticalityMatrix")
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            Router.self.token = UserDefaults.standard.token
            
            let userInformation = UserDefaults.standard.userInformation
            
            Alamofire.request(
                Router.getCriticalityMatrix(processID: userInformation.processID,
                                            subprocessID: userInformation.subProcessID,
                                            originID: userInformation.originID))
                .responseArray { (response: DataResponse<[CriticalityMatrixResponse]>) in
                    switch response.result {
                    case .success(let criticalityResponse):
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            case 200:
                                //Check for valid status
                                if criticalityResponse.contains(where: { $0.status?.id == "176"} ) {
                                    //SMS Authentication
                                    if criticalityResponse.contains(where: { $0.factor?.id == TypesFactor.phone.rawValue} ) {
                                        UserDefaults.standard.canUseSMSTokenAuthentication = true
                                    }
                                    
                                    //Email Authentication
                                    if criticalityResponse.contains(where: { $0.factor?.id == TypesFactor.email.rawValue} ) {
                                        UserDefaults.standard.canUseEmailTokenAuthentication = true
                                    }
                                }
                                
                                // Save values criticalityMatrix
                                var arrayCriticalityMatrix:[Factor] = []
                                for object in criticalityResponse {
                                    let factor = Factor(id: object.factor!.id!, validity:object.validity!.autentication!, uuid: nil)
                                    arrayCriticalityMatrix.append(factor)
                                }
                                UserDefaults.standard.arrayCriticalityMatrix = arrayCriticalityMatrix
                                
                                // Validate if authentication methods save
                                self.countArrayFactors = 0
                                self.arrayFactors = UserDefaults.standard.arrayFactors
                                // Match between factor save vs criticality matrix
                                for i in 0..<self.arrayFactors.count {
                                    if !criticalityResponse.contains(where: {$0.factor?.id == self.arrayFactors[i].id}) {
                                        self.arrayFactors.remove(at: i)
                                    }
                                }
                                
                                if self.arrayFactors.count > 0 {
                                    //Check validity authentication factor
                                    self.getValidityAuthenticationFactor()
                                } else {
                                    //Check authentication methods of the user
                                    self.getProfileAuthenticationMethods()
                                }
                                break
                            default:
                                self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                            }
                        }
                    case .failure(_):
                        self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                    }
                }
        } else {
            self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
        }
    }
    
    /**
     Consult the validity time of authentication method
     */
    func getValidityAuthenticationFactor() {
        print("MAU: getValidityAuthenticationFactor")
        //Set parameters
        let factor : Factor = self.arrayFactors[self.countArrayFactors]
        let userInformation = UserDefaults.standard.userInformation
        
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            Router.self.token = UserDefaults.standard.token
            
            Alamofire.request(
                Router.getValidityAuthentication(curp: userInformation.curp,
                                                 factorID: factor.id,
                                                 uuid: factor.uuid,
                                                 sessionID: userInformation.sessionID))
                .responseObject { (response: DataResponse<ValidityAuthenticationResponse>) in
                    switch response.result {
                    case .success(let validityResponse):
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            case 200:
                                if let result = validityResponse.result,
                                   result == "vigente" {
                                    self.arrayFactors[self.countArrayFactors].isValid =  true
                                    self.sendBitacoraAuthenticationFactor(factorID: self.arrayFactors[self.countArrayFactors].id)
                                    self.countArrayFactors += 1
                                } else {
                                    self.arrayFactors[self.countArrayFactors].isValid =  false
                                    self.countArrayFactors += 1
                                    if self.countArrayFactors >= self.arrayFactors.count {
                                        self.applyNewFactorValues()
                                    } else {
                                        self.getValidityAuthenticationFactor()
                                    }
                                }
                                break
                            default:
                                self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                            }
                        }
                    case .failure(_):
                        self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                    }
                }
        } else {
            self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
        }
    }
    
    /**
     Send the bitacora time of authentication method
     */
    func sendBitacoraAuthenticationFactor(factorID : String) {
        print("MAU: sendBitacoraAuthenticationFactor")
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
            Alamofire.request(Router.previousAuthentication(curp: userInformation.curp, parameters: parameters))
                .responseObject { (response: DataResponse<ValueID>) in
                switch response.result {
                case .success(_):
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 200:
                            if self.countArrayFactors >= self.arrayFactors.count {
                                self.applyNewFactorValues()
                            } else {
                                self.getValidityAuthenticationFactor()
                            }
                        default:
                            self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                        }
                    }
                case .failure(_):
                    self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                }
            }
        } else {
            self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
        }
    }
    
    private func applyNewFactorValues() {
        var existValidation = 0;
        // Remove not valid data
        self.arrayFactors = self.arrayFactors.filter {$0.isValid != false}
        
        var temp = UserDefaults.standard.arrayFactors
        for factor1 in self.arrayFactors {
            for i in 0..<temp.count {
                let factor2 = temp[i]
                if factor1.id == factor2.id && !factor1.isValid {
                    temp.remove(at: i)
                    break
                }
            }
            if factor1.isValid {
                existValidation += 1
            }
        }
        
        // Save new values in factors
        UserDefaults.standard.arrayFactors = temp
        if existValidation > 0 {
            self.selectAuthenticationMethodDelegate?.showAuthenticationSuccessful()
        } else {
            self.getProfileAuthenticationMethods()
        }
    }
    
    /**
     Get the authentication information for the user
     */
    func getProfileAuthenticationMethods() {
        print("MAU: getProfileAuthenticationMethods")
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            Router.self.token = UserDefaults.standard.token
            
            let userInformation = UserDefaults.standard.userInformation
            
            Alamofire.request(
                Router.getProfile(curp: userInformation.curp))
                .responseObject { (response: DataResponse<ProfileResponse>) in
                    switch response.result {
                    case .success(let profileResponse):
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            case 200:
                                //Set values of the user from BAU
                                if let emailData = profileResponse.emailData {
                                    if let email = emailData.email {
                                        userInformation.email = email
                                    } else {
                                        UserDefaults.standard.canUseEmailTokenAuthentication = false
                                    }
                                    UserDefaults.standard.userInformation = userInformation
                                } else {
                                    UserDefaults.standard.canUseEmailTokenAuthentication = false
                                }
                                
                                if let phoneData = profileResponse.phoneNumberData {
                                    if let phoneNumber = phoneData.phoneNumber {
                                        userInformation.phoneNumber = phoneNumber
                                    } else {
                                        UserDefaults.standard.canUseSMSTokenAuthentication = false
                                    }
                                    UserDefaults.standard.userInformation = userInformation
                                } else {
                                    UserDefaults.standard.canUseSMSTokenAuthentication = false
                                }
                                
                                self.getDailyAttempts(factorID: TypesFactor.phone)
                            default:
                                self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                            }
                        }
                    case .failure(_):
                        self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                    }
                }
        } else {
            self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
        }
    }
    
    /**
     Check if the authentication method has attempts
     */
    func getDailyAttempts(factorID: TypesFactor) {
        print("MAU: getDailyAttempts")
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            Router.self.token = UserDefaults.standard.token
            
            let userInformation = UserDefaults.standard.userInformation
            
            Alamofire.request(
                Router.getRemainingAttempts(curp: userInformation.curp, processID: userInformation.processID, subprocessID: userInformation.subProcessID, originID: userInformation.originID, factorID: Int(factorID.rawValue)!))
                .responseObject { (response: DataResponse<DailyAttemptsResponse>) in
                    switch response.result {
                    case .success(let attemptsResponse):
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            case 200:
                                
                                let attempts = Int(attemptsResponse.attempts ?? "0") ?? 0
                                
                                switch factorID {
                                case TypesFactor.phone:
                                    UserDefaults.standard.hasDailyAttemptsOfSMS = attempts < 1 ? false : true
                                    
                                    UserDefaults.standard.canUseSMSTokenAuthentication = UserDefaults.standard.hasDailyAttemptsOfSMS && UserDefaults.standard.canUseSMSTokenAuthentication
                                    
                                    self.getDailyAttempts(factorID: TypesFactor.email)
                                case TypesFactor.email:
                                    UserDefaults.standard.hasDailyAttemptsOfEmail = attempts < 1 ? false : true
                                    
                                    UserDefaults.standard.canUseEmailTokenAuthentication = UserDefaults.standard.hasDailyAttemptsOfEmail && UserDefaults.standard.canUseEmailTokenAuthentication
                                    
                                    self.getDailyAttempts(factorID: TypesFactor.facial)
                                case TypesFactor.facial:
                                    
                                    UserDefaults.standard.hasDailyAttemptsOfFacial = attempts < 1 ? false : true
                                    
                                    UserDefaults.standard.canUseFacialAuthentication = UserDefaults.standard.hasDailyAttemptsOfFacial
                                    // Clear edit data status
                                    UserDefaults.standard.canUseEmailTokenDM = true
                                    UserDefaults.standard.canUseSMSTokenDM = true
                                    self.getEditDataStatus(factor: "correo");
                                }
                                break
                            default:
                                self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                            }
                        }
                    case .failure(_):
                        self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                    }
                }
        } else {
            self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
        }
    }
    
    /**
     Check if user have a edit data in progress
     - Parameter factor (correo / celular)
     */
    func getEditDataStatus(factor: String) {
        print("MAU: getEditDataStatus")
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            Router.self.token = UserDefaults.standard.token
            
            let userInformation = UserDefaults.standard.userInformation
            
            Alamofire.request(
                Router.getValidateEditData(account: userInformation.account, factor: factor))
                .responseObject { (response: DataResponse<EditDataResponse>) in
                    switch response.result {
                    case .success(let editDataResponse):
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            case 200, 404:
                                if let values = editDataResponse.md {
                                    // Exist Edit Data in progress
                                    if values.count > 0 {
                                        if factor == "correo" {
                                            UserDefaults.standard.canUseEmailTokenDM = false
                                        } else {
                                            UserDefaults.standard.canUseSMSTokenDM = false
                                        }
                                    }
                                }
                                if factor == "correo" {
                                    self.getEditDataStatus(factor: "celular");
                                } else {
                                    self.getValidationUsersMethods()
                                }
                                break
                            default:
                                self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                            }
                        }
                    case .failure(_):
                        self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                    }
                }
        } else {
            self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
        }
    }
    // MARK: OLA3
    /**
     Get the validation information for the user
     */
    func getValidationUsersMethods() {
        print("MAU: getValidationUsersMethods")
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            Router.self.token = UserDefaults.standard.token
            
            let userInformation = UserDefaults.standard.userInformation
            let forceEnroll = userInformation.forceEnroll
            let binnacle: [String: Any] = [
                "idProceso": userInformation.processID,
                "idSubProceso": userInformation.subProcessID,
                "idOrigen": userInformation.originID,
                "idFactor": "159"
            ]
            let parameters: [String: Any] = [
                "curp": userInformation.curp,
                "cveOrigen": userInformation.cveOrigin,
                "cveEntSolicitante": userInformation.cveEntity,
                "cveOperacion": userInformation.cveOperation,
                "tipoUsuario": userInformation.userType,
                "dataBitacora": binnacle
            ]
            
            Alamofire.request(
                Router.validateAuthentication(businessLine: userInformation.businessLine, parameters: parameters))
                .responseObject { (response: DataResponse<ValidateUserResponse>) in
                    if forceEnroll {
                        UserDefaults.standard.isUserEnrolled = false
                        UserDefaults.standard.tokenOperation = "kjdhadjada="
                        
                        self.selectAuthenticationMethodDelegate?.setAuthenticationMethodsFromCriticality()
                        self.selectAuthenticationMethodDelegate?.hideLoader()
                    } else {
                        switch response.result {
                        case .success(let userResponse):
                            if let httpStatusCode = response.response?.statusCode {
                                switch httpStatusCode {
                                case 200:
                                    let active = "01"
                                    let enrollFacial = userResponse.enrollFacial ?? "00"
                                    UserDefaults.standard.isUserEnrolled = enrollFacial == active
                                    UserDefaults.standard.tokenOperation = userResponse.token ?? ""
                                    if let list = userResponse.listDiagnosticsOp {
                                        if list.isEmpty {
                                            self.selectAuthenticationMethodDelegate?.setAuthenticationMethodsFromCriticality()
                                            self.selectAuthenticationMethodDelegate?.hideLoader()
                                        } else {
                                            self.validateFlow(listOper: list)
                                        }
                                    } else {
                                        self.selectAuthenticationMethodDelegate?.setAuthenticationMethodsFromCriticality()
                                        self.selectAuthenticationMethodDelegate?.hideLoader()
                                    }
                                case 400, 401, 404, 500, 503:
                                    self.selectAuthenticationMethodDelegate?.showRequestFailed()
                                default:
                                    self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                                }
                            }
                        case .failure(_):
                            self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                        }
                    }
                }
        } else {
            self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
        }
    }
    
    /**
     Validate listOperation to continue or stop the flow
     */
    func validateFlow(listOper: [String]) {
        let specialCases = listOper.contains(where: { code in
            code == "A12"
        })
        
        let userInformation = UserDefaults.standard.userInformation
        if userInformation.businessLine != "922" && specialCases {
            self.selectAuthenticationMethodDelegate?.setAuthenticationMethodsFromCriticality()
            self.selectAuthenticationMethodDelegate?.hideLoader()
        } else {
            self.getMessageResponse(listOper: listOper)
        }
    }
    
    /**
     Get messages
     */
    func getMessageResponse(listOper: [String]) {
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            Router.self.token = UserDefaults.standard.token
            
            let parameters: [String: Any] = ["listaDiagnosticosOp": listOper]
            
            Alamofire.request(
                Router.getMessages(parameters: parameters))
                .responseObject { (response: DataResponse<MessageResponse>) in
                    switch response.result {
                    case .success(let messageResponse):
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            case 200:
                                if let list = messageResponse.listMessages {
                                    if list.isEmpty {
                                        self.selectAuthenticationMethodDelegate?.showRequestFailed()
                                    } else {
                                        var message = ""
                                        for item in list {
                                            if let processId = item.processId {
                                                message += "\(processId) - "
                                            }
                                            
                                            if let msg = item.userMessage {
                                                message += "\(msg)"
                                            }
                                            
                                            message += "\n"
                                        }
                                        self.selectAuthenticationMethodDelegate?.showErrorMessage(error: message)
                                        self.selectAuthenticationMethodDelegate?.hideLoader()
                                    }
                                }
                            default:
                                self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                            }
                        }
                    case .failure(_):
                        self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                    }
                }
        } else {
            self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
        }
    }
}
