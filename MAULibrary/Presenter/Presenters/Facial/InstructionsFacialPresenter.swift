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
import FWFaceAuth

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
                            self.saveStatus()
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
    // MARK: OLA 3
    /**
     Enroll or Validation
     */
    func enrollOrValidation(token: String, operation: String, response: FaceAuthModel.Response) {
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            Router.self.token = UserDefaults.standard.token
            let userInformation = UserDefaults.standard.userInformation
            
            guard let selfie = response.selphiResult.image.jpegData(compressionQuality: 0.95) else {
                self.instructionsFacialDelegate?.showConnectionErrorMessage()
                return
            }
            
            let isEnrolled = UserDefaults.standard.isUserEnrolled
            var front: Data?
            var back: Data?
            if !isEnrolled {
                if let frontID = response.selphIdResult?.frontImage {
                    front = frontID.jpegData(compressionQuality: 0.95)
                }
                
                if let backID = response.selphIdResult?.backImage {
                    back = backID.jpegData(compressionQuality: 0.95)
                }
            }
            
            let (list, urlDir, zip) = createZIP(selfie: selfie, frontID: front, backID: back)
            guard let urlTemp = urlDir else {
                self.instructionsFacialDelegate?.showConnectionErrorMessage()
                return
            }
            
            guard let base64 = zip else {
                removeTemp(directoryTemp: urlTemp)
                self.instructionsFacialDelegate?.showConnectionErrorMessage()
                return
            }
            
            let binnacle: [String: Any] = [
                "idProceso": userInformation.processID,
                "idSubProceso": userInformation.subProcessID,
                "idOrigen": userInformation.originID,
                "idFactor": "159"
            ]
            let parameters: [String : Any] = [
                "cveOrigen" : userInformation.cveOrigin,
                "cveEntidad": userInformation.cveEntity,
                "curp": userInformation.curp,
                "token": token,
                "cveOperacion": operation,
                "listaImagen" : list,
                "archivoBase64" : base64,
                "dataBitacora": binnacle
            ]
            
            Alamofire.request(Router.enrollOrValidation(parameters: parameters))
                .responseObject { (response: DataResponse<EnrollOrValidationResponse>) in
                    self.removeTemp(directoryTemp: urlTemp)
                    switch response.result {
                        case .success(let result):
                            if let httpStatusCode = response.response?.statusCode {
                                switch httpStatusCode {
                                    case 200:
                                        if let list = result.listOp {
                                            if list.isEmpty {
                                                self.checkFlow(result: result)
                                            } else {
                                                self.getMessageResponse(listOper: list)
                                            }
                                        } else {
                                            self.checkFlow(result: result)
                                        }
                                    default:
                                        self.instructionsFacialDelegate?.showConnectionErrorMessage()
                                }
                            } else {
                                self.instructionsFacialDelegate?.showConnectionErrorMessage()
                            }
                        case .failure(_):
                            self.instructionsFacialDelegate?.showConnectionErrorMessage()
                    }
            }
        } else {
            self.instructionsFacialDelegate?.showConnectionErrorMessage()
        }
    }
    
    private func createZIP(selfie: Data, frontID: Data?, backID: Data?) -> ([String], URL?, String?) {
        // Obtaining the Location of the Documents Directory
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dir = documentDirectory.appendingPathComponent("temp")
        do {
            try FileManager.default.createDirectory(atPath: dir.path, withIntermediateDirectories: true, attributes: nil)
            // Create URL
            let urlSelfie = dir.appendingPathComponent("01.jpg")
            var list = ["01"]
            do {
                try selfie.write(to: urlSelfie)
                
                if let frontID = frontID {
                    let urlFront = dir.appendingPathComponent("02.jpg")
                    try frontID.write(to: urlFront)
                    list.append("02")
                }
                
                if let backID = backID {
                    let urlBack = dir.appendingPathComponent("03.jpg")
                    try backID.write(to: urlBack)
                    list.append("03")
                }
                
                let (result, url) = zip(itemAtURL: dir, in: dir, zipName: "temp.zip")
                if result == "" {
                    do {
                        let dataZIP = try Data(contentsOf: url!)
                        let base64 = dataZIP.base64EncodedString()
                        return (list, dir, base64)
                    } catch {
                        print("MAU: Error to base64")
                    }
                    
                    return (list, dir, nil)
                }
                
                return (list, dir, nil)
            } catch {
                return ([], dir, nil)
            }
        } catch {
            return ([], nil, nil)
        }
    }
    
    private func zip(itemAtURL itemURL: URL, in destinationFolderURL: URL, zipName: String) -> (String, URL?) {
        var error: NSError?
        var internalError: NSError?
        var finalUrl: URL!
        NSFileCoordinator().coordinate(readingItemAt: itemURL, options: [.forUploading], error: &error) { (zipUrl) in
            // zipUrl points to the zip file created by the coordinator
            // zipUrl is valid only until the end of this block, so we move the file to a temporary folder
            finalUrl = destinationFolderURL.appendingPathComponent(zipName)
            do {
                try FileManager.default.moveItem(at: zipUrl, to: finalUrl)
            } catch let localError {
                internalError = localError as NSError
            }
        }
        
        if let error = error {
            return (error.localizedDescription, nil)
        }
        if let internalError = internalError {
            return (internalError.localizedDescription, nil)
        }
        
        return ("", finalUrl)
    }
    
    private func removeTemp(directoryTemp: URL) {
        if FileManager.default.fileExists(atPath: directoryTemp.path) {
            do {
                try FileManager.default.removeItem(atPath: directoryTemp.path)
            } catch {
                print("MAU: Could not delete file, probably read-only filesystem")
            }
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
                                        self.instructionsFacialDelegate?.showConnectionErrorMessage()
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
                                        self.instructionsFacialDelegate?.showErrorMessage(error: message)
                                        self.instructionsFacialDelegate?.hideLoader()
                                    }
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
    
    private func checkFlow(result: EnrollOrValidationResponse) {
        let isEnrolled = UserDefaults.standard.isUserEnrolled
        if !isEnrolled {
            if let op = result.resultOp, let enroll = result.enroll,
               op == "01" && enroll == "01" {
                self.instructionsFacialDelegate?.showAuthenticationSuccesful()
            } else {
                self.instructionsFacialDelegate?.failedRequest()
            }
        } else {
            if let validation = result.resultValidation,
               validation == "MATCH" {
                self.saveValidityAuthentication()
            } else {
                self.instructionsFacialDelegate?.failedRequest()
            }
        }
    }
    
    /**
     Save Status
     */
    func saveStatus() {
        //Check internet connection
        let reachability = try! Reachability()
        
        //Consumption
        if reachability.connection != .unavailable {
            Router.self.token = UserDefaults.standard.token
            let userInformation = UserDefaults.standard.userInformation
            
            let params: [String : Any] = [
                "idProceso": userInformation.processID,
                "idSubProceso": userInformation.subProcessID,
                "estado": "2"
            ]
            
            let parameters: [String : Any] = ["tramite": params]
            
            Alamofire.request(Router.saveStatus(curp: userInformation.curp, parameters: parameters))
                .responseObject { (response: DataResponse<SaveSatusResponse>) in
                    switch response.result {
                        case .success(_):
                            self.instructionsFacialDelegate?.showAuthenticationSuccesful()
                        case .failure(_):
                            self.instructionsFacialDelegate?.failedRequest()
                    }
            }
        } else {
            self.instructionsFacialDelegate?.showConnectionErrorMessage()
        }
    }
}

