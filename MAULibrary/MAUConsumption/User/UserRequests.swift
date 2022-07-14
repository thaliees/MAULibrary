//
//  UserRequests.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 11/02/21.
//

import Foundation
import Reachability
import Alamofire
import AlamofireObjectMapper

class UserRequests {
    
    /**
     Request a new access token to consume the web services of the MAU
     
     - Parameter completion: Closure to continue with the next service consumption.
     - Parameter token: Access token for API consumption
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection and 1 if is a successful response
     */
    func getAccessToken(completion: @escaping (_ token: String, _ responseCode: Int) -> ()) {
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            //Set internal developer token
            ConsumptionRouter.self.internalToken = Keys.tokenKey
            ConsumptionRouter.self.token = nil
            
            Alamofire.request(ConsumptionRouter.requestAccessToken).responseObject { (response: DataResponse<TokenResponse>) in
                switch response.result {
                case .success(let tokenResponse):
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 200:
                            if let token = tokenResponse.token {
                                UserDefaults.standard.mauToken = token
                                completion(token, 1)
                            } else {
                                completion("Estatus 200, error", -1)
                            }
                        default:
                            completion("Estatus !200, error", -1)
                        }
                    }
                case .failure(_):
                    completion("Falló la solicitud", -1)
                }
            }
        } else {
            completion("Conexión Fallida", 0)
        }
    }
    
    /**
     Retrives the user's profile information (CURP, facial biometrics, fingerprint biometrics, phone number, email and BAU data)
     
     - Parameter completion: Closure to manage the response of the service
     - Parameter response: Response object
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection and 1 if is a successful response
     */
    func getProfile(curp: String, completion: @escaping (_ response: ProfileResponse?, _ responseCode: Int) -> Void) {
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            ConsumptionRouter.self.token = UserDefaults.standard.mauToken
            
            Alamofire.request(ConsumptionRouter.getProfileInformation(curp: curp)).responseObject { (response: DataResponse<ProfileResponse>) in
                switch response.result {
                case .success(let profileResponse):
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 200:
                            completion(profileResponse, 1)
                        default:
                            completion(nil, -1)
                        }
                    }
                case .failure(_):
                    completion(nil, -1)
                }
            }
        } else {
            completion(nil, 0)
        }
    }
    
    /**
     Check the criticality matrix for specific process, subprocess and origin ID's
     - Parameter processID: ID of the process
     - Parameter subprocessID: ID of the subprocess
     - Parameter originID: ID of the origin
     - Parameter completion: Closure to manage the response of the service
     - Parameter response: Response object
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection and 1 if is a successful response
     */
    func getCriticalityMatrix(processID: Int, subprocessID: Int, originID: Int, completion: @escaping (_ response: [CriticalityMatrixResponse]?, _ responseCode: Int) -> Void) {
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            ConsumptionRouter.self.token = UserDefaults.standard.mauToken
            
            Alamofire.request(
                ConsumptionRouter.getCriticalityMatrix(processID: processID,
                                                       subprocessID: subprocessID,
                                                       originID: originID))
                .responseArray { (response: DataResponse<[CriticalityMatrixResponse]>) in
                    switch response.result {
                    case .success(let criticalityResponse):
                        if let httpStatusCode = response.response?.statusCode {
                            switch httpStatusCode {
                            case 200:
                                completion(criticalityResponse, 1)
                            default:
                                completion([], -1)
                            }
                        }
                    case .failure(_):
                        completion([], -1)
                    }
                }
        } else {
            completion([], 0)
        }
    }
    
    /**
     Create a new profile in the BAU for a user with the required information
     
     - Parameter curp: Client's CURP
     - Parameter fullName: Client's full name
     - Parameter bucID: ID in the BUC
     - Parameter reasonID: ID of the reason
     - Parameter originID: ID of the origin
     - Parameter roleID: ID of the role
     - Parameter prospectName: Prospect's name
     - Parameter prospectLastName: Prospect's last name
     - Parameter prospectMothersLastName: Prospect's mother's last name
     - Parameter completion: Closure to manage the response of the service
     - Parameter response: Response object
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection and 1 if is a successful response
     */
    func createUserProfile(curp: String, fullName: String, bucID: Int, reasonID: Int, originID: Int, roleID: Int, prospectName: String, prospectLastName: String, prospectMothersLastName: String, completion: @escaping (_ response: ProfileCreationResponse?, _ responseCode: Int) -> Void) {
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            ConsumptionRouter.self.token = UserDefaults.standard.mauToken
            
            let parameters: [String: Any] = [
                "datosPersona": [
                    "usuario": fullName,
                    "idBuc": "\(bucID)",
                    "motivo": ["id": "\(reasonID)"],
                    "origen": ["id": "\(originID)"],
                    "rol": ["id": "\(roleID)"]
                ],
                "datosProspecto": [
                    "nombre": prospectName,
                    "apellidoPaterno": prospectLastName,
                    "apellidoMaterno": prospectMothersLastName
                ]
            ]
            
            Alamofire.request(ConsumptionRouter.createUserProfile(curp: curp, parameters: parameters)).responseObject { (response: DataResponse<ProfileCreationResponse>) in
                switch response.result {
                case .success(let profileCreationResponse):
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 200:
                            completion(profileCreationResponse, 1)
                        default:
                            completion(nil, -1)
                        }
                    }
                case .failure(_):
                    completion(nil, -1)
                }
            }
        } else {
            completion(nil, 0)
        }
    }
    
    /**
     Get the privacy policy of a specific business line
     - Parameter businessLine: ID of the business line
     - Parameter completion: Closure to manage the response information.
     - Parameter privacyPolicyResponse: Response object. Only contains a non-empty array when the responseCode is 1.
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection and 1 if is a successful response
     */
    func getPrivacyPolicy(businessLine: Int, completion: @escaping (_ privacyPolicyResponse: PrivacyPolicyResponse?, _ responseCode: Int) -> ()) {
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            ConsumptionRouter.self.token = UserDefaults.standard.mauToken
            
            Alamofire.request(ConsumptionRouter.getPrivacyPolicy(businessLine: businessLine)).responseObject { (response: DataResponse<PrivacyPolicyResponse>) in
                switch response.result {
                case .success(let privacyPolicyResponse):
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 200:
                            completion(privacyPolicyResponse, 1)
                        default:
                            completion(nil, -1)
                        }
                    }
                case .failure(_):
                    completion(nil, -1)
                }
            }
        } else {
            completion(nil, 0)
        }
    }
    
    /**
     Get the status of the privacy policy signed by a user.
     - Parameter curp: Client's CURP
     - Parameter completion: Closure to manage the response information.
     - Parameter privacyPolicyStatusResponse: Response object. Only contains a non-empty array when the responseCode is 1.
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection and 1 if is a successful response
     */
    func getPrivacyPolicyStatus(curp: String, completion: @escaping (_ privacyPolicyStatusResponse: PrivacyPolicyStatusResponse?, _ responseCode: Int) -> ()) {
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            ConsumptionRouter.self.token = UserDefaults.standard.mauToken
            
            Alamofire.request(ConsumptionRouter.getPrivacyPolicyStatus(curp: curp)).responseObject { (response: DataResponse<PrivacyPolicyStatusResponse>) in
                switch response.result {
                case .success(let privacyPolicyStatusResponse):
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 200:
                            completion(privacyPolicyStatusResponse, 1)
                        default:
                            completion(nil, -1)
                        }
                    }
                case .failure(_):
                    completion(nil, -1)
                }
            }
        } else {
            completion(nil, 0)
        }
    }
    
    /**
     Saves the status of the signed privacy policy
     - Parameter curp: Client's CURP
     - Parameter businessLine: ID of the business line
     - Parameter userName: Client's full name
     - Parameter latitude: Latitude of the location of the user
     - Parameter longitude: Longitude of the location of the user
     - Parameter completion: Closure to manage the response information.
     - Parameter privacyPolicyStatusResponse: Response object. Only contains a non-empty array when the responseCode is 1.
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection and 1 if is a successful response
     */
    func savePrivacyPolicyResponse(curp: String, businessLine: Int, userName: String, latitude: String, longitude: String, completion: @escaping (_ savePrivacyPolicyResponse: SavePrivacyPolicyResponse?, _ responseCode: Int) -> ()) {
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            ConsumptionRouter.self.token = UserDefaults.standard.mauToken
            
            let parameters: [String: Any] = [
                "lineaNegocio": ["id": "\(businessLine)"],
                "usuario": userName,
                "coordenadas": ["latitud": latitude, "longitud": longitude]
            ]
            
            Alamofire.request(ConsumptionRouter.savePrivacyPolicyResponse(curp: curp, parameters: parameters)).responseObject { (response: DataResponse<SavePrivacyPolicyResponse>) in
                switch response.result {
                case .success(let savePrivacyPolicyResponse):
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 200:
                            completion(savePrivacyPolicyResponse, 1)
                        default:
                            completion(nil, -1)
                        }
                    }
                case .failure(_):
                    completion(nil, -1)
                }
            }
        } else {
            completion(nil, 0)
        }
    }
    
    /**
     To know if the client (using the CURP) has ARCO rights
     - Parameter curp: Client's CURP
     - Parameter completion: Closure to manage the response information.
     - Parameter arcoResponse: Response object. Only contains a non-empty array when the responseCode is 1.
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection and 1 if is a successful response
     */
    func hasARCORights(curp: String, completion: @escaping (_ arcoResponse: ARCOResponse?, _ responseCode: Int) -> ()) {
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            ConsumptionRouter.self.token = UserDefaults.standard.mauToken
            
            let parameters: [String: Any] = [
                "rqt": [
                    "curp": curp
                ]
            ]
            
            Alamofire.request(ConsumptionRouter.getARCO(parameters: parameters)).responseObject { (response: DataResponse<ARCOResponse>) in
                switch response.result {
                case .success(let arcoResponse):
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 200:
                            completion(arcoResponse, 1)
                        default:
                            completion(nil, -1)
                        }
                    }
                case .failure(_):
                    completion(nil, -1)
                }
            }
        } else {
            completion(nil, 0)
        }
    }
    
    /**
     To know if the client (using the full name) has REUS rights
     - Parameter name: Client's name
     - Parameter lastName: Client's last name
     - Parameter mothersLastName: Client's mother's last name
     - Parameter completion: Closure to manage the response information.
     - Parameter reusResponse: Response object. Only contains a non-empty array when the responseCode is 1.
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection and 1 if is a successful response
     */
    func hasREUSRights(name: String, lastName: String, mothersLastName: String, completion: @escaping (_ reusResponse: REUSResponse?, _ responseCode: Int) -> ()) {
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            ConsumptionRouter.self.token = UserDefaults.standard.mauToken
            
            let parameters: [String: Any] = [
                "rqt": [
                    "nombre": name,
                    "apPaterno": lastName,
                    "apMaterno": mothersLastName
                ]
            ]
            
            Alamofire.request(ConsumptionRouter.getREUS(parameters: parameters)).responseObject { (response: DataResponse<REUSResponse>) in
                switch response.result {
                case .success(let reusResponse):
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 200:
                            completion(reusResponse, 1)
                        default:
                            completion(nil, -1)
                        }
                    }
                case .failure(_):
                    completion(nil, -1)
                }
            }
        } else {
            completion(nil, 0)
        }
    }
    
    /**
     Get the session Id
     
     - Parameter completion: Closure to continue with the next service consumption.
     - Parameter token: Access token for API consumption
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection and 1 if is a successful response
     */
    func getSessionId(completion: @escaping (_ token: String, _ responseCode: Int) -> ()) {
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            ConsumptionRouter.self.token = UserDefaults.standard.mauToken
            
            Alamofire.request(ConsumptionRouter.getSessionId).responseObject { (response: DataResponse<IdentificatorResponse>) in
                switch response.result {
                case .success(let tokenResponse):
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 200:
                            if let token = tokenResponse.id {
                                completion(token, 1)
                            } else {
                                completion("Estatus 200, error: getSessionId", -1)
                            }
                        default:
                            completion("Estatus !200, error: getSessionId", -1)
                        }
                    }
                case .failure(_):
                    completion("Falló la solicitud, error: getSessionId", -1)
                }
            }
        } else {
            completion("Conexión fallida, getSessionId", 0)
        }
    }
}
