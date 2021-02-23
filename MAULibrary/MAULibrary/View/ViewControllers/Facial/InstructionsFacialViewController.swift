//
//  InstructionsFacialViewController.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 12/01/21.
//

import UIKit
import FWFaceAuth
import NVActivityIndicatorView

class InstructionsFacialViewController: UIViewController {
    
    //MARK: - UI Properties
    @IBOutlet var extensionView: UIView!
    
    //MARK: - Logic Properties
    var mauDelegate: AuthenticationMAU?
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createUIInitialModifications()
    }
    
    //MARK: - Actions
    /**
     Action when the continue button is tapped
     */
    @IBAction func continueTapped(_ sender: UIButton) {
        let faceAuth = FaceAuth(delegate: self)
        
        let uiConfiguration = FaceAuthModel.UIConfiguration(activityIndicator: ActivityData(), withInstructions: true)
        
        let userInformation = UserDefaults.standard.userInformation
        
        let request = FaceAuthModel.Request(
            client: userInformation.client,
            account: userInformation.account,
            curp: userInformation.curp,
            nombre: userInformation.name,
            apellidoPaterno: userInformation.lastName,
            apellidoMaterno: userInformation.mothersLastName,
            origenID: Int(userInformation.originID)!,
            processID: Int(userInformation.processID)!,
            subProcessID: Int(userInformation.subProcessID)!,
            appBundle: Bundle(for: type(of: self)))
        
        faceAuth.startFaceAuth(request: request, uiConfiguration: uiConfiguration)
    }
    
    //MARK: - UI Modifications
    /**
     Adds initial modifications to the UI (like back buttons, navigation bar)
     */
    func createUIInitialModifications() {
        //Reset custom navigation bar
        self.resetNavigationBarCustomization()
        
        //Add back button
        self.addCustomBackButton()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.customizeWithProfuturoBar(view: extensionView)
    }
}

//MARK: - UIGestureRecognizerDelegate
extension InstructionsFacialViewController: UIGestureRecognizerDelegate { }

//MARK: - FaceAuthDelegate
extension InstructionsFacialViewController: FaceAuthDelegate {
    func showViewController<T>(viewController: T, error: Bool) {
        if let faceAuthVC = viewController as? FaceAuthViewController {
            navigationController?.pushViewController(faceAuthVC, animated: true)
        }
    }
    
    func responseHandler(response: FaceAuthModel.Response) {
        mauDelegate?.authentication(wasSuccesful: response.authResult ?? false)
    }
    
    func removeBlur() { }
}
