//
//  EnterTokenViewController.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 05/01/21.
//

import UIKit
import SVPinView

class EnterTokenViewController: UIViewController {
    
    //MARK: - UI Properties
    @IBOutlet var extensionView: UIView!
    @IBOutlet var tokenIndication: UILabel!
    @IBOutlet var value: UILabel!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var otpField: SVPinView!
    @IBOutlet var resendCode: UIButton!
    var animationView: LoaderAnimation!
    
    //MARK: - Logic Properties
    let presenter = EnterTokenPresenter()
    /// Variable to know if the token is email
    var isEmail = false
    /// Saves the OTP code
    var otpCode = ""
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.setViewDelegate(enterTokenDelegate: self)
        
        createUIInitialModifications()
        createOTPField()
        defineObservers()
        
        animationView = LoaderAnimation()
        
        //Conditional when the authentication method will be email or SMS
        if isEmail {
            presenter.sendEmailToken()
        } else {
            presenter.sendSMSToken()
        }

    }
    
    //MARK: - Logic
    /**
     Defines the observers for this ViewControllers, specifically for connection errors
     */
    func defineObservers() {
        NotificationCenter.default.addObserver(forName: Notification.Name(NotificationObserverServices.closeEnterToken.rawValue), object: nil, queue: nil) { _ in
            self.animationView.hideLoaderView()
            self.navigationController?.popViewController(animated: true)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(NotificationObserverServices.tryAgainAuthentication.rawValue), object: nil, queue: nil) {
            _ in
            self.animationView.hideLoaderView()
            
            if (!UserDefaults.standard.canUseFacialAuthentication) {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    //MARK: - Actions
    /**
     Action when the resend button is tapped
     */
    @IBAction func resendCodeTapped(_ sender: UIButton) {
        if isEmail {
            presenter.resendEmailToken()
        } else {
            presenter.resendSMSToken()
        }
    }
    
    /**
     Action when the continue button is tapped
     */
    @IBAction func continueTapped(_ sender: UIButton) {
        presenter.validateToken(otpCode: otpCode, isEmail: isEmail)
    }
    
    //MARK: - Objective C functions
    /**
     Action called when the user taps outside the keyboard
     */
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - UI Modifications
    /**
     Adds initial modifications to the UI (like back buttons, navigation bar)
     */
    func createUIInitialModifications() {
        self.addCustomBackButton()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.customizeWithProfuturoBar(view: extensionView)
        
        //Add the dismiss feature to keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Change labels if is email or sms authentication
        if isEmail {
            tokenIndication.text = "Ingresa el código a 6 dígitos\nque recibiste al correo electrónico:"
            value.text = UserDefaults.standard.userInformation.email.maskEmail()
        } else {
            value.text = UserDefaults.standard.userInformation.phoneNumber.maskPhone()
        }
        
        //Add underline to resend label
        resendCode.underline()
    }
    
    /**
     Customize the OTP field of the pod SVPinView
     */
    func createOTPField() {
        otpField.pinLength = 6
        otpField.textColor = UIColor(named: "SkyBlue")!
        otpField.style = .underline
        otpField.font = UIFont(name: "Roboto-Light", size: 48)!
        otpField.keyboardType = .numberPad
        otpField.keyboardAppearance = .default
        otpField.isContentTypeOneTimeCode = true
        otpField.deleteButtonAction = .deleteCurrentAndMoveToPrevious
        otpField.activeBorderLineColor = UIColor(named: "FieldGray")!
        otpField.allowsWhitespaces = false
        otpField.borderLineColor = UIColor(named: "FieldGray")!
        otpField.borderLineThickness = 1
        otpField.activeBorderLineThickness = 1
        otpField.shouldSecureText = false
        
        otpField.didFinishCallback = { otp in
            self.otpCode = otp
        }
        
        otpField.didChangeCallback = { otp in
            print(otp)
        }
    }
}

//MARK: - UIGestureRecognizerDelegate
extension EnterTokenViewController: UIGestureRecognizerDelegate { }

//MARK: - EnterTokenDelegate
extension EnterTokenViewController: EnterTokenDelegate {
    func showLoader() {
        animationView.showLoaderView()
    }
    
    func hideLoader() {
        animationView.hideLoaderView()
    }
    
    func showConnectionErrorMessage() {
        let connectionErrorVC = ConnectionErrorViewController.instantiateFromAppStoryboard(appStoryboard: .dialogs)
        connectionErrorVC.observerToCall = .closeEnterToken
        connectionErrorVC.modalPresentationStyle = .overFullScreen
        animationView.stopAnimation()
        present(connectionErrorVC, animated: true)
    }
    
    func showAuthenticationSuccesful() {
        let authenticationSuccessfulVC = AuthenticationSuccessfulViewController.instantiateFromAppStoryboard(appStoryboard: .dialogs)
        authenticationSuccessfulVC.modalPresentationStyle = .overFullScreen
        animationView.stopAnimation()
        present(authenticationSuccessfulVC, animated: true)
    }
    
    func showAuthenticationError() {
        let authenticationErrorVC = AuthenticationErrorViewController.instantiateFromAppStoryboard(appStoryboard: .dialogs)
        authenticationErrorVC.observerToCall = .tryAgainAuthentication
        authenticationErrorVC.modalPresentationStyle = .overFullScreen
        animationView.stopAnimation()
        present(authenticationErrorVC, animated: true)
    }
}
