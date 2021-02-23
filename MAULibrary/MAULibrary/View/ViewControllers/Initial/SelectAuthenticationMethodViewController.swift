//
//  SelectAuthenticationMethodViewController.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 17/12/20.
//

import UIKit
import Lottie

public protocol AuthenticationMAU {
    func authentication(wasSuccesful: Bool)
}

class SelectAuthenticationMethodViewController: UIViewController {
    
    //MARK: - UI Properties
    @IBOutlet var extensionView: UIView!
    @IBOutlet var faceAuthView: UIView!
    @IBOutlet var blockedFaceAuthView: UIView!
    @IBOutlet var tokenAuthView: UIView!
    @IBOutlet var blockedTokenAuthView: UIView!
    @IBOutlet var facialQuestionMark: UIImageView!
    @IBOutlet var tokenQuestionMark: UIImageView!
    var animationView: LoaderAnimation!
    
    //MARK: - Logic Properties
    let presenter = SelectAuthenticationMethodPresenter()
    //This object comes from the main application
    var user: User!
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Save user information
        //DUMMY DATA
        user = User(name: "Ángel Eduardo", lastName: "Domínguez", mothersLastName: "Delgado", client: "0", account: "", curp: "DODA961018HVZMLN06", processID: "226", subProcessID: "406", originID: "34")
        //END DUMMY DATA
        UserDefaults.standard.userInformation = user
        
        presenter.setViewDelegate(selectAuthenticationMethodDelegate: self)
        
        self.customizeWithProfuturoBar(view: extensionView)
        addGesturesToViews()
        defineObservers()
        
        animationView = LoaderAnimation()
        presenter.generateToken()
    }
    
    //MARK: - Logic
    /**
     Add tapped gestures to the views
     */
    func addGesturesToViews() {
        faceAuthView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(faceAuthTapped)))
        facialQuestionMark.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(facialQMTapped)))
        tokenAuthView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tokenAuthTapped)))
        tokenQuestionMark.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tokenQMTapped)))
    }
    
    /**
     Defines the observers for this ViewControllers, specifically for connection errors
     */
    func defineObservers() {
        NotificationCenter.default.addObserver(forName: Notification.Name(NotificationObserverServices.closeMAU.rawValue), object: nil, queue: nil) { _ in
            self.dismiss(animated: true)
        }
    }
    
    //MARK: - Actions
    /**
     Actions when the "I don't have ID" button is tapped
     */
    @IBAction func noIDTapped(_ sender: UIButton) {
        if UserDefaults.standard.canUseFacialAuthentication {
            let contactInformationVC = ContactInformationViewController.instantiateFromAppStoryboard(appStoryboard: .initial)
            contactInformationVC.modalPresentationStyle = .overFullScreen
            present(contactInformationVC, animated: true, completion: nil)
        }
    }
    
    //MARK: - Objective C functions
    /**
     Action when the Face Authentication is tapped
     */
    @objc func faceAuthTapped() {
        if UserDefaults.standard.canUseFacialAuthentication {
            let instructionsFacialVC = InstructionsFacialViewController.instantiateFromAppStoryboard(appStoryboard: .facial)
            navigationController?.pushViewController(instructionsFacialVC, animated: true)
        }
    }
    
    /**
     Action when the Token Authentication is tapped
     */
    @objc func tokenAuthTapped() {
        if UserDefaults.standard.canUseEmailTokenAuthentication || UserDefaults.standard.canUseSMSTokenAuthentication {
            let tokenPreinformationVC = TokenPreInformationViewController.instantiateFromAppStoryboard(appStoryboard: .token)
            navigationController?.pushViewController(tokenPreinformationVC, animated: true)
        }
    }
    
    /**
     Action when the Facial question mark is tapped
     */
    @objc func facialQMTapped() {
        if UserDefaults.standard.canUseFacialAuthentication {
            let stepsFacialVC = StepsFacialViewController.instantiateFromAppStoryboard(appStoryboard: .initial)
            stepsFacialVC.modalPresentationStyle = .overFullScreen
            present(stepsFacialVC, animated: true, completion: nil)
        }
    }
    
    /**
     Action when the token question mark is tapped
     */
    @objc func tokenQMTapped() {
        if UserDefaults.standard.canUseEmailTokenAuthentication || UserDefaults.standard.canUseSMSTokenAuthentication {
            let stepsTokenVC = StepsTokenViewController.instantiateFromAppStoryboard(appStoryboard: .initial)
            stepsTokenVC.modalPresentationStyle = .overFullScreen
            present(stepsTokenVC, animated: true)
        }
    }
}

//MARK: - SelectAuthenticationMethodDelegate
extension SelectAuthenticationMethodViewController: SelectAuthenticationMethodDelegate {
    func showConnectionErrorMessage() {
        let connectionErrorVC = ConnectionErrorViewController.instantiateFromAppStoryboard(appStoryboard: .dialogs)
        connectionErrorVC.modalPresentationStyle = .overFullScreen
        connectionErrorVC.observerToCall = .closeMAU
        animationView.stopAnimation()
        self.present(connectionErrorVC, animated: true)
    }
    
    func showLoader() {
        animationView.showLoaderView()
    }
    
    func hideLoader() {
        animationView.hideLoaderView()
    }
    
    func setAuthenticationMethodsFromCriticality() {
        blockedTokenAuthView.isHidden = UserDefaults.standard.canUseTokenAuthentication
        blockedFaceAuthView.isHidden = UserDefaults.standard.canUseFacialAuthentication
        
        if (!UserDefaults.standard.canUseFacialAuthentication && UserDefaults.standard.canUseTokenAuthentication) {
            let tokenPreinformationVC = TokenPreInformationViewController.instantiateFromAppStoryboard(appStoryboard: .token)
            navigationController?.pushViewController(tokenPreinformationVC, animated: true)
        } else if (!UserDefaults.standard.canUseTokenAuthentication && UserDefaults.standard.canUseFacialAuthentication) {
            let instructionsFacialVC = InstructionsFacialViewController.instantiateFromAppStoryboard(appStoryboard: .facial)
            navigationController?.pushViewController(instructionsFacialVC, animated: true)
        }
    }
}
