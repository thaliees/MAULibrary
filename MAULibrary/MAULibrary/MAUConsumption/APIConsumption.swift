//
//  APIConsumption.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 11/02/21.
//

import Foundation

public class APIConsumption {
    
    /**
     Retrives the user's profile information (CURP, facial biometrics, fingerprint biometrics, phone number, email and BAU data)
     
     - Parameter curp: Client CURP
     - Parameter completion: Closure to manage the response information.
     - Parameter profileResponse: Response object from the server. Only contains a value when responseCode is 1.
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection and 1 if is a successful response
     */
    public static func getUserProfile(of curp: String, completion: @escaping (_ profileResponse: ProfileResponse?, _ responseCode: Int) -> ()) {
        UserRequests().getAccessToken() { token, code in
            switch code {
            case -1:
                completion(nil, code)
            case 0:
                completion(nil, code)
            case 1:
                UserRequests().getProfile(curp: curp) { profileResponse, code in
                    completion(profileResponse, code)
                }
            default:
                completion(nil, -1)
            }
        }
    }
    
    /**
     Check the criticality matrix for specific process, subprocess and origin ID's
     
     - Parameter processID: ID of the process
     - Parameter subprocessID: ID of the subprocess
     - Parameter originID: ID of the origin
     - Parameter completion: Closure to manage the response information.
     - Parameter criticalityMatrixResponse: Response object. Only contains a non-empty array when the responseCode is 1.
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection and 1 if is a successful response
     */
    public static func getCriticalityMatrix(processID: Int, subprocessID: Int, originID: Int, completion: @escaping (_ criticalityMatrixResponse: [CriticalityMatrixResponse]?, _ responseCode: Int) -> ()) {
        UserRequests().getAccessToken() { token, code in
            switch code {
            case -1:
                completion([], code)
            case 0:
                completion([], code)
            case 1:
                UserRequests().getCriticalityMatrix(processID: processID, subprocessID: subprocessID, originID: originID) { criticalityResponse, code in
                    completion(criticalityResponse, code)
                }
            default:
                completion([], -1)
            }
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
     - Parameter completion: Closure to manage the response information.
     - Parameter profileCreationResponse: Response object. Only contains a non-empty array when the responseCode is 1.
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection and 1 if is a successful response
     */
    public static func createUserProfile(curp: String, fullName: String, bucID: Int, reasonID: Int, originID: Int, roleID: Int, prospectName: String, prospectLastName: String, prospectMothersLastName: String, completion: @escaping (_ profileCreationResponse: ProfileCreationResponse?, _ responseCode: Int) -> ()) {
        UserRequests().getAccessToken() { token, code in
            switch code {
            case -1:
                completion(nil, code)
            case 0:
                completion(nil, code)
            case 1:
                UserRequests().createUserProfile(curp: curp, fullName: fullName, bucID: bucID, reasonID: reasonID, originID: originID, roleID: roleID, prospectName: prospectName, prospectLastName: prospectLastName, prospectMothersLastName: prospectMothersLastName) { profileCreationResponse, code in
                    completion(profileCreationResponse, code)
                }
            default:
                completion(nil, -1)
            }
        }
    }
    
    /**
     Get the privacy policy of a specific business line
     - Parameter businessLine: ID of the business line
     - Parameter completion: Closure to manage the response information.
     - Parameter privacyPolicyResponse: Response object. Only contains a non-empty array when the responseCode is 1.
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection and 1 if is a successful response
     */
    public static func getPrivacyPolicy(businessLine: Int, completion: @escaping (_ privacyPolicyResponse: PrivacyPolicyResponse?, _ responseCode: Int) -> ()) {
        UserRequests().getAccessToken() { token, code in
            switch code {
            case -1:
                completion(nil, code)
            case 0:
                completion(nil, code)
            case 1:
                UserRequests().getPrivacyPolicy(businessLine: businessLine) { privacyPolicyResponse, code in
                    completion(privacyPolicyResponse, code)
                }
            default:
                completion(nil, -1)
            }
        }
    }
    
    /**
     Get the status of the privacy policy signed by a user.
     - Parameter curp: Client's CURP
     - Parameter completion: Closure to manage the response information.
     - Parameter privacyPolicyStatusResponse: Response object. Only contains a non-empty array when the responseCode is 1.
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection and 1 if is a successful response
     */
    public static func getPrivacyPolicyStatus(curp: String, completion: @escaping (_ privacyPolicyStatusResponse: PrivacyPolicyStatusResponse?, _ responseCode: Int) -> ()) {
        UserRequests().getAccessToken() { token, code in
            switch code {
            case -1:
                completion(nil, code)
            case 0:
                completion(nil, code)
            case 1:
                UserRequests().getPrivacyPolicyStatus(curp: curp) { privacyPolicyStatusResponse, code in
                    completion(privacyPolicyStatusResponse, code)
                }
            default:
                completion(nil, -1)
            }
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
    public static func savePrivacyPolicyResponse(curp: String, businessLine: Int, userName: String, latitude: String, longitude: String, completion: @escaping (_ savePrivacyPolicyResponse: SavePrivacyPolicyResponse?, _ responseCode: Int) -> ()) {
        UserRequests().getAccessToken() { token, code in
            switch code {
            case -1:
                completion(nil, code)
            case 0:
                completion(nil, code)
            case 1:
                UserRequests().savePrivacyPolicyResponse(curp: curp, businessLine: businessLine, userName: userName, latitude: latitude, longitude: longitude) { savePrivacyPolicyResponse, code in
                    completion(savePrivacyPolicyResponse, code)
                }
            default:
                completion(nil, -1)
            }
        }
    }
    
    /**
     To know if the client (using the CURP) has ARCO rights
     - Parameter curp: Client's CURP
     - Parameter completion: Closure to manage the response information.
     - Parameter hasARCO: Return true if has ARCO rights and false if not
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection and 1 if is a successful response
     */
    public static func hastARCORights(curp: String, completion: @escaping (_ hasARCO: Bool, _ responseCode: Int) -> ()) {
        UserRequests().getAccessToken() { token, code in
            switch code {
            case -1:
                completion(false, code)
            case 0:
                completion(false, code)
            case 1:
                UserRequests().hasARCORights(curp: curp) { arcoResponse, code in
                    if let hasARCO = arcoResponse?.hasARCO {
                        completion(hasARCO == "SI", code)
                    } else {
                        completion(false, code)
                    }
                }
            default:
                completion(false, -1)
            }
        }
    }
    
    /**
     To know if the client (using the full name) has REUS rights
     - Parameter name: Client's name
     - Parameter lastName: Client's last name
     - Parameter mothersLastName: Client's mother's last name
     - Parameter completion: Closure to manage the response information.
     - Parameter hasREUS: Return true if has REUS rights and false if not
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection and 1 if is a successful response
     */
    public static func hasREUSRights(name: String, lastName: String, mothersLastName: String, completion: @escaping (_ hasREUS: Bool, _ responseCode: Int) -> ()) {
        UserRequests().getAccessToken() { token, code in
            switch code {
            case -1:
                completion(false, code)
            case 0:
                completion(false, code)
            case 1:
                UserRequests().hasREUSRights(name: name, lastName: lastName, mothersLastName: mothersLastName) { reusResponse, code in
                    if let hasREUS = reusResponse?.hasREUS {
                        completion(hasREUS == "SI", code)
                    } else {
                        completion(false, code)
                    }
                }
            default:
                completion(false, -1)
            }
        }
    }
    
    /**
     Sends a new token to the client's phone number
     - Parameter curp: Client's CURP
     - Parameter processID: ID of the process
     - Parameter subprocessID: ID of the subprocess
     - Parameter originID: ID of the origin
     - Parameter phoneNumber: Client's phone number
     - Parameter tokenSended: Tells if the token was sended to the client
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection, 1 if is a successful response and 3 if the user exceeded daily trys.
     */
    public static func sendSMSToken(curp: String, processID: Int, subprocessID: Int, originID: Int, phoneNumber: String, completion: @escaping (_ tokenSended: Bool, _ responseCode: Int) -> ()) {
        UserRequests().getAccessToken() { token, code in
            switch code {
            case -1:
                completion(false, code)
            case 0:
                completion(false, code)
            case 1:
                TokenRequests().sendSMSToken(curp: curp, processID: processID, subprocessID: subprocessID, originID: originID, phoneNumber: phoneNumber) { tokenSended, code in
                    completion(tokenSended, code)
                }
            default:
                completion(false, -1)
            }
        }
    }
    
    /**
     Sends a new token to the client's phone number
     - Parameter curp: Client's CURP
     - Parameter processID: ID of the process
     - Parameter subprocessID: ID of the subprocess
     - Parameter originID: ID of the origin
     - Parameter phoneNumber: Client's phone number
     - Parameter tokenSended: Tells if the token was sended to the client
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection, 1 if is a successful response and 2 if the token expired and you need to create a new one.
     */
    public static func resendSMSToken(curp: String, processID: Int, subprocessID: Int, originID: Int, phoneNumber: String, completion: @escaping (_ tokenSended: Bool, _ responseCode: Int) -> ()) {
        UserRequests().getAccessToken() { token, code in
            switch code {
            case -1:
                completion(false, code)
            case 0:
                completion(false, code)
            case 1:
                TokenRequests().resendSMSToken(curp: curp, processID: processID, subprocessID: subprocessID, originID: originID, phoneNumber: phoneNumber) { tokenSended, code in
                    completion(tokenSended, code)
                }
            default:
                completion(false, -1)
            }
        }
    }
    
    /**
     Sends a new token to the client's email
     - Parameter curp: Client's CURP
     - Parameter processID: ID of the process
     - Parameter subprocessID: ID of the subprocess
     - Parameter originID: ID of the origin
     - Parameter clientEmail: Client's email
     - Parameter tokenSended: Tells if the token was sended to the client
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection, 1 if is a successful response and 3 if the user exceeded daily trys.
     */
    public static func sendEmailToken(curp: String, processID: Int, subprocessID: Int, originID: Int, clientEmail: String, completion: @escaping (_ tokenSended: Bool, _ responseCode: Int) -> ()) {
        UserRequests().getAccessToken() { token, code in
            switch code {
            case -1:
                completion(false, code)
            case 0:
                completion(false, code)
            case 1:
                TokenRequests().sendEmailToken(curp: curp, processID: processID, subprocessID: subprocessID, originID: originID, clientEmail: clientEmail) { tokenSended, code in
                    completion(tokenSended, code)
                }
            default:
                completion(false, -1)
            }
        }
    }
    
    /**
     Sends a new token to the client's email
     - Parameter curp: Client's CURP
     - Parameter processID: ID of the process
     - Parameter subprocessID: ID of the subprocess
     - Parameter originID: ID of the origin
     - Parameter clientEmail: Client's email
     - Parameter tokenSended: Tells if the token was sended to the client
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection, 1 if is a successful response and 2 if the token expired and you need to create a new one.
     */
    public static func resendEmailToken(curp: String, processID: Int, subprocessID: Int, originID: Int, clientEmail: String, completion: @escaping (_ tokenSended: Bool, _ responseCode: Int) -> ()) {
        UserRequests().getAccessToken() { token, code in
            switch code {
            case -1:
                completion(false, code)
            case 0:
                completion(false, code)
            case 1:
                TokenRequests().sendEmailToken(curp: curp, processID: processID, subprocessID: subprocessID, originID: originID, clientEmail: clientEmail) { tokenSended, code in
                    completion(tokenSended, code)
                }
            default:
                completion(false, -1)
            }
        }
    }
    
    /**
     Sends a new token to the client's email
     - Parameter curp: Client's CURP
     - Parameter processID: ID of the process
     - Parameter subprocessID: ID of the subprocess
     - Parameter originID: ID of the origin
     - Parameter token: Token to validate
     - Parameter isEmailToken: true if the token comes from email
     - Parameter isValid: Tells if the token is valid with the one stored in the server
     - Parameter responseCode: Internal value for flow control. It returns -1 if is a server error, 0 if don't have Internet connection and 1 if is a successful response.
     */
    public static func validateToken(curp: String, processID: Int, subprocessID: Int, originID: Int, token: String, isEmailToken: Bool, completion: @escaping (_ isValid: Bool, _ responseCode: Int) -> ()) {
        UserRequests().getAccessToken() { token, code in
            switch code {
            case -1:
                completion(false, code)
            case 0:
                completion(false, code)
            case 1:
                TokenRequests().validateToken(curp: curp, processID: processID, subprocessID: subprocessID, originID: originID, token: token, isEmailToken: isEmailToken) { validToken, code in
                    completion(validToken, code)
                }
            default:
                completion(false, -1)
            }
        }
    }
}
