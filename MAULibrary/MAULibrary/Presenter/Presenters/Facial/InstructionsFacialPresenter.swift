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
}

