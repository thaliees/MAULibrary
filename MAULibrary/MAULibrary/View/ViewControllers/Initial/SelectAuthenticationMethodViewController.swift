//
//  SelectAuthenticationMethodViewController.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 17/12/20.
//

import UIKit
import Lottie

public class SelectAuthenticationMethodViewController: UIViewController {
    
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
    //Observers
    var closeMAUObserver: NSObjectProtocol!
    
    //MARK: - Init
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.setViewDelegate(selectAuthenticationMethodDelegate: self)
        
        createUIInitialModifications()
        addGesturesToViews()
        
        animationView = LoaderAnimation()
        presenter.generateToken()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Add observers
        defineObservers()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Remove observers
        NotificationCenter.default.removeObserver(closeMAUObserver)
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
        closeMAUObserver = NotificationCenter.default.addObserver(forName: Notification.Name(NotificationObserverServices.closeMAUSelectAuthentication.rawValue), object: nil, queue: nil) { _ in
            self.hideLoader()
            self.navigationController?.popViewController(animated: false)
            NotificationCenter.default.post(name: Notification.Name(NotificationObserverServices.authenticationDenied.rawValue), object: nil)
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
    
    //MARK: - UI Modifications
    /**
     Adds initial modifications to the UI (like back buttons, navigation bar)
     */
    func createUIInitialModifications() {
        //Add back button
        self.addCustomBackButton()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.customizeWithProfuturoBar(view: extensionView)
    }
}

//MARK: - SelectAuthenticationMethodDelegate
extension SelectAuthenticationMethodViewController: SelectAuthenticationMethodDelegate {
    func showConnectionErrorMessage() {
        let connectionErrorVC = ConnectionErrorViewController.instantiateFromAppStoryboard(appStoryboard: .dialogs)
        connectionErrorVC.observerToCall = .closeMAUSelectAuthentication
        connectionErrorVC.modalPresentationStyle = .overFullScreen
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
        } else if (!UserDefaults.standard.canUseFacialAuthentication && !UserDefaults.standard.canUseTokenAuthentication) {
            NotificationCenter.default.post(name: Notification.Name(NotificationObserverServices.closeMAUSelectAuthentication.rawValue), object: nil)
        }
    }
}

//MARK: - UIGestureRecognizerDelegate
extension SelectAuthenticationMethodViewController: UIGestureRecognizerDelegate { }
