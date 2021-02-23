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
        
        #if DEBUG
        print(reachability.connection)
        #endif
        
        //Consumption
        reachability.whenReachable = { _ in
            
            if reachability.connection == .cellular || reachability.connection == .wifi {
                //Set internal developer token
                Router.self.internalToken = Keys.tokenKey
                
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
                    case .failure(let error):
                        #if DEBUG
                        print(error)
                        #endif
                        self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                    }
                }
            }
        }
        reachability.whenUnreachable = { _ in
            self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
        }
    }
    
    /**
     Consult the criticality matrix for processes and subprocesses
     */
    func getCriticalityMatrix() {
        //Check internet connection
        let reachability = try! Reachability()
        
        #if DEBUG
        print(reachability.connection)
        #endif
        
        //Consumption
        reachability.whenReachable = { _ in
            
            if reachability.connection == .cellular || reachability.connection == .wifi {
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
                                        
                                        //Facial Authentication
                                        if criticalityResponse.contains(where: { $0.factor?.id == "159"} ) {
                                            UserDefaults.standard.canUseFacialAuthentication = true
                                        }
                                    }
                                    
                                    //Check authentication methods of the user
                                    self.getProfileAuthenticationMethods()
                                    break
                                default:
                                    self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                                }
                            }
                        case .failure(let error):
                            #if DEBUG
                            print(error)
                            #endif
                            self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                        }
                    }
            }
        }
        reachability.whenUnreachable = { _ in
            self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
        }
    }
    
    /**
     Get the authentication information for the user
     */
    func getProfileAuthenticationMethods() {
        //Check internet connection
        let reachability = try! Reachability()
        
        #if DEBUG
        print(reachability.connection)
        #endif
        
        //Consumption
        reachability.whenReachable = { _ in
            
            if reachability.connection == .cellular || reachability.connection == .wifi {
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
                                    
                                    if !(profileResponse.facialBiometricsData != nil) {
                                        UserDefaults.standard.canUseFacialAuthentication = false
                                    }
                                    
                                    self.selectAuthenticationMethodDelegate?.setAuthenticationMethodsFromCriticality()
                                    self.selectAuthenticationMethodDelegate?.hideLoader()
                                default:
                                    self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                                }
                            }
                        case .failure(let error):
                            #if DEBUG
                            print(error)
                            #endif
                            self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
                        }
                    }
            }
        }
        reachability.whenUnreachable = { _ in
            self.selectAuthenticationMethodDelegate?.showConnectionErrorMessage()
        }
    }
}
