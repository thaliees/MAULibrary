//
//  InstructionsFacialViewController.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 12/01/21.
//

import UIKit
import FWFaceAuth
import NVActivityIndicatorView
import Lottie

class InstructionsFacialViewController: UIViewController {
    
    //MARK: - UI Properties
    @IBOutlet var extensionView: UIView!
    @IBOutlet weak var helpText: UILabel!
    @IBOutlet weak var textID: UILabel!

    //MARK: - Logic Properties
    let presenter = InstructionsFacialPresenter()
    /// Loader for the view
    let animationView = LoaderAnimation()
    //Observers
    var closeMAUPassedObserver: NSObjectProtocol!
    var closeMAUDeniedObserver: NSObjectProtocol!
    var tryAgainObserver: NSObjectProtocol!
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.setViewDelegate(instructionsFacialDelegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createUIInitialModifications()
        
        let isEnrolled = UserDefaults.standard.isUserEnrolled
        if isEnrolled {
            helpText.text = "Vamos a tomarte una selfie"
            textID.isHidden = true
        }

        //Add observers
        defineObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Remove observers
        NotificationCenter.default.removeObserver(closeMAUDeniedObserver)
        NotificationCenter.default.removeObserver(closeMAUPassedObserver)
        NotificationCenter.default.removeObserver(tryAgainObserver)
    }
    
    //MARK: - Logic
    /**
     Defines the observers for this ViewControllers, specifically for connection errors
     */
    func defineObservers() {
        closeMAUPassedObserver = NotificationCenter.default.addObserver(forName: Notification.Name(NotificationObserverServices.closeMAUPassedFacial.rawValue), object: nil, queue: nil) { _ in
            self.animationView.hideLoaderView()
            let parentVC = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
            self.navigationController?.popToViewController(parentVC!, animated: false)
            NotificationCenter.default.post(name: Notification.Name(NotificationObserverServices.authenticationPassed.rawValue), object: nil)
        }
        
        closeMAUDeniedObserver = NotificationCenter.default.addObserver(forName: Notification.Name(NotificationObserverServices.closeMAUInstructionsFacial.rawValue), object: nil, queue: nil) { _ in
            self.animationView.hideLoaderView()
            let parentVC = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
            self.navigationController?.popToViewController(parentVC!, animated: false)
            NotificationCenter.default.post(name: Notification.Name(NotificationObserverServices.authenticationDenied.rawValue), object: nil)
        }
        
        tryAgainObserver = NotificationCenter.default.addObserver(forName: Notification.Name(NotificationObserverServices.tryAgainAuthenticationInFacial.rawValue), object: nil, queue: nil) {
            _ in
            self.animationView.hideLoaderView()
            
            if (UserDefaults.standard.canUseTokenAuthentication) {
                let selectAuthenticationVC = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2]
                self.navigationController?.popToViewController(selectAuthenticationVC!, animated: false)
            }
        }
    }
    
    //MARK: - Actions
    /**
     Action when the continue button is tapped
     */
    @IBAction func continueTapped(_ sender: UIButton) {
        animationView.showLoaderView()
        
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
            origenID: userInformation.originID,
            processID: userInformation.processID,
            subProcessID: userInformation.subProcessID,
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
    func modalViewController<T>(viewController: T) { }
    
    func hiddenModalViewController() { }
    
    func showViewController<T>(viewController: T, error: Bool) {
        animationView.hideLoaderView()
        if let faceAuthVC = viewController as? FaceAuthViewController {
            navigationController?.pushViewController(faceAuthVC, animated: true)
        }
    }
    
    func responseHandler(response: FaceAuthModel.Response) {
        if let authResult = response.authResult {
            if authResult {
                animationView.showLoaderView()
                presenter.enrollOrValidation(response: response)
            } else {
                presenter.getFacialAttempts()
            }
        } else {
            presenter.getFacialAttempts()
        }
    }
    
    func removeBlur() { }
}

//MARK: - InstructionsFacialDelegate
extension InstructionsFacialViewController: InstructionsFacialDelegate {
    func showFacialAttempts() {
        let hasFacialAttempts = UserDefaults.standard.hasDailyAttemptsOfFacial
        
        if hasFacialAttempts {
            let canUseAnotherAuthenticationOption = UserDefaults.standard.canUseSMSTokenAuthentication || UserDefaults.standard.canUseEmailTokenAuthentication || UserDefaults.standard.canUseFacialAuthentication
            
            let authenticationErrorVC = AuthenticationErrorViewController.instantiateFromAppStoryboard(appStoryboard: .dialogs)
            authenticationErrorVC.observerToCall = .tryAgainAuthenticationInFacial
            authenticationErrorVC.observerToCallClose = .closeMAUInstructionsFacial
            authenticationErrorVC.showTryAgainButton = canUseAnotherAuthenticationOption
            authenticationErrorVC.modalPresentationStyle = .overFullScreen
            animationView.stopAnimation()
            present(authenticationErrorVC, animated: true)
        } else {
            UserDefaults.standard.canUseFacialAuthentication = false
            
            let canUseAnotherAuthenticationOption = UserDefaults.standard.canUseSMSTokenAuthentication || UserDefaults.standard.canUseEmailTokenAuthentication
            
            if canUseAnotherAuthenticationOption {
                let limitExceededVC = LimitExceededTryAnotherViewController.instantiateFromAppStoryboard(appStoryboard: .dialogs)
                limitExceededVC.observerToCall = .tryAgainAuthenticationInFacial
                limitExceededVC.closeObserverToCall = .closeMAUInstructionsFacial
                limitExceededVC.modalPresentationStyle = .overFullScreen
                animationView.stopAnimation()
                present(limitExceededVC, animated: true)
            } else {
                let limitExceededVC = LimitExceededViewController.instantiateFromAppStoryboard(appStoryboard: .dialogs)
                limitExceededVC.observerToCall = .closeMAUInstructionsFacial
                limitExceededVC.modalPresentationStyle = .overFullScreen
                animationView.stopAnimation()
                present(limitExceededVC, animated: true)
            }
        }
    }
    
    func showAuthenticationSuccesful() {
        let isEnrolled = UserDefaults.standard.isUserEnrolled
        let authenticationSuccessfulVC = AuthenticationSuccessfulViewController.instantiateFromAppStoryboard(appStoryboard: .dialogs)
        authenticationSuccessfulVC.observerToCall = .closeMAUPassedFacial
        authenticationSuccessfulVC.modalPresentationStyle = .overFullScreen
        if !isEnrolled {
            authenticationSuccessfulVC.changeText = true
            authenticationSuccessfulVC.text = "Biometría facial exitosa"
        }
        animationView.stopAnimation()
        present(authenticationSuccessfulVC, animated: true)
    }
    
    func showLoader() {
        animationView.showLoaderView()
    }
    
    func hideLoader() {
        animationView.hideLoaderView()
    }
    
    func showConnectionErrorMessage() {
        let connectionErrorVC = ConnectionErrorViewController.instantiateFromAppStoryboard(appStoryboard: .dialogs)
        connectionErrorVC.observerToCall = .closeMAUInstructionsFacial
        connectionErrorVC.modalPresentationStyle = .overFullScreen
        animationView.stopAnimation()
        self.present(connectionErrorVC, animated: true)
    }
    
    func showErrorMessage(error: String, showTryAgain: Bool) {
        let authenticationErrorVC = AuthenticationErrorViewController.instantiateFromAppStoryboard(appStoryboard: .dialogs)
        authenticationErrorVC.observerToCall = .tryAgainAuthenticationInFacial
        authenticationErrorVC.observerToCallClose = .closeMAUInstructionsFacial
        authenticationErrorVC.showTryAgainButton = showTryAgain
        authenticationErrorVC.showError = true
        authenticationErrorVC.error = error
        authenticationErrorVC.modalPresentationStyle = .overFullScreen
        animationView.stopAnimation()
        present(authenticationErrorVC, animated: true)
    }
}
