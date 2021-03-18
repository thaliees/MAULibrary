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
    //Facial card
    @IBOutlet var selfieImage: UIImageView!
    @IBOutlet var facialPrimaryInstruction: UILabel!
    @IBOutlet var facialSecondaryInstruction: UILabel!
    @IBOutlet var dontHaveIDButton: UIButton!
    //Token card
    @IBOutlet var tokenImage: UIImageView!
    @IBOutlet var tokenPrimaryInstruction: UILabel!
    @IBOutlet var tokenSecondaryInstruction: UILabel!
    
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
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Add observers
        defineObservers()
        
        //Refresh information
        presenter.generateToken()
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
        
        let canUseToken = UserDefaults.standard.canUseTokenAuthentication
        let canUseFacial = UserDefaults.standard.canUseFacialAuthentication
        
        //Facial modifications
        blockedFaceAuthView.isHidden = canUseFacial
        selfieImage.image = canUseFacial ? UIImage(named: "selfie") : UIImage(named: "selfieGray")
        facialPrimaryInstruction.textColor = canUseFacial ? UIColor(named: "NavyBlue") : UIColor(named: "IntentGray")
        facialSecondaryInstruction.textColor = canUseFacial ? UIColor(named: "GrayText") : UIColor(named: "IntentGray")
        facialQuestionMark.image = canUseFacial ? UIImage(named: "question") : UIImage(named: "questionGray")
        
        //Token modifications
        blockedTokenAuthView.isHidden = canUseToken
        tokenImage.image = canUseToken ? UIImage(named: "password") : UIImage(named: "passwordGray")
        tokenPrimaryInstruction.textColor = canUseToken ? UIColor(named: "NavyBlue") : UIColor(named: "IntentGray")
        tokenSecondaryInstruction.textColor = canUseToken ? UIColor(named: "GrayText") : UIColor(named: "IntentGray")
        tokenQuestionMark.image = canUseToken ? UIImage(named: "question") : UIImage(named: "questionGray")
        
        let hasFacialAttempts = UserDefaults.standard.hasDailyAttemptsOfFacial
        let hasTokenAttempts = UserDefaults.standard.hasDailyAttemptsOfSMS && UserDefaults.standard.hasDailyAttemptsOfEmail
        
        facialSecondaryInstruction.text = hasFacialAttempts ? "Ten a la mano tu INE/IFE o Pasaporte vigente" : "Has excedido el número de intentos,\nvuelve a intentarlo en 24 hrs."
        dontHaveIDButton.isHidden = !hasFacialAttempts
        
        tokenSecondaryInstruction.text = hasTokenAttempts ? "Recibirás un código de 6 dígitos en tu\ncelular o correo electrónico" : "Has excedido el número de intentos,\nvuelve a intentarlo en 24 hrs."
        

        /*if (!canUseFacial && canUseToken) {
            let tokenPreinformationVC = TokenPreInformationViewController.instantiateFromAppStoryboard(appStoryboard: .token)
            navigationController?.pushViewController(tokenPreinformationVC, animated: true)
        } else if (!canUseToken && canUseFacial) {
            let instructionsFacialVC = InstructionsFacialViewController.instantiateFromAppStoryboard(appStoryboard: .facial)
            navigationController?.pushViewController(instructionsFacialVC, animated: true)
        } else if (!canUseFacial && !canUseToken) {
            NotificationCenter.default.post(name: Notification.Name(NotificationObserverServices.closeMAUSelectAuthentication.rawValue), object: nil)
        }*/
    }
}

//MARK: - UIGestureRecognizerDelegate
extension SelectAuthenticationMethodViewController: UIGestureRecognizerDelegate { }
