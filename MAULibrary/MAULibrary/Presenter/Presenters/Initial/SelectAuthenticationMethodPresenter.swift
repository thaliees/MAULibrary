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
    
    //MARK: - Logic
    /**
     Generates a new token to request petitions to the server
     */
    func generateToken() {
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
                                    if criticalityResponse.contains(where: { $0.factor?.id == "154"} ) {
                                        UserDefaults.standard.canUseSMSTokenAuthentication = true
                                    }
                                    
                                    //Email Authentication
                                    if criticalityResponse.contains(where: { $0.factor?.id == "155"} ) {
                                        UserDefaults.standard.canUseEmailTokenAuthentication = true
                                    }
                                }
                                
                                //Check authentication methods of the user
                                self.getProfileAuthenticationMethods()
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
     Get the authentication information for the user
     */
    func getProfileAuthenticationMethods() {
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
                                
                                self.getDailyAttempts(factorID: 154)
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
    func getDailyAttempts(factorID: Int) {
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            Router.self.token = UserDefaults.standard.token
            
            let userInformation = UserDefaults.standard.userInformation
            
            Alamofire.request(
                Router.getRemainingAttempts(curp: userInformation.curp, processID: userInformation.processID, subprocessID: userInformation.subProcessID, originID: userInformation.originID, factorID: factorID))
                .responseObject { (response: DataResponse<DailyAttemptsResponse>) in
                    switch response.result {
                    case .success(let attemptsResponse):
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            case 200:
                                
                                let attempts = Int(attemptsResponse.attempts ?? "0") ?? 0
                                
                                switch factorID {
                                case 154:
                                    UserDefaults.standard.hasDailyAttemptsOfSMS = attempts < 1 ? false : true
                                    
                                    UserDefaults.standard.canUseSMSTokenAuthentication = UserDefaults.standard.hasDailyAttemptsOfSMS && UserDefaults.standard.canUseSMSTokenAuthentication
                                    
                                    
                                    self.getDailyAttempts(factorID: 155)
                                case 155:
                                    UserDefaults.standard.hasDailyAttemptsOfEmail = attempts < 1 ? false : true
                                    
                                    UserDefaults.standard.canUseEmailTokenAuthentication = UserDefaults.standard.hasDailyAttemptsOfEmail && UserDefaults.standard.canUseEmailTokenAuthentication
                                    
                                    self.getDailyAttempts(factorID: 159)
                                case 159:
                                    UserDefaults.standard.hasDailyAttemptsOfFacial = attempts < 1 ? false : true
                                    
                                    UserDefaults.standard.canUseFacialAuthentication = UserDefaults.standard.hasDailyAttemptsOfFacial
                                    
                                    self.selectAuthenticationMethodDelegate?.setAuthenticationMethodsFromCriticality()
                                    self.selectAuthenticationMethodDelegate?.hideLoader()
                                default:
                                    break
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
