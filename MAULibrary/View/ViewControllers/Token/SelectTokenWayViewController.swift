//
//  SelectTokenWayViewController.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 17/12/20.
//

import UIKit

class SelectTokenWayViewController: UIViewController {
    
    //MARK: - UI Properties
    @IBOutlet var extensionView: UIView!
    @IBOutlet var cellphoneNumberToSend: UILabel!
    @IBOutlet var emailToSend: UILabel!
    @IBOutlet var cellphoneView: UIView!
    @IBOutlet var blockedCellphoneView: UIView!
    @IBOutlet var emailView: UIView!
    @IBOutlet var blockedEmailView: UIView!
    @IBOutlet var smsTokenImage: UIImageView!
    @IBOutlet var emailTokenImage: UIImageView!
    @IBOutlet var smsSecondaryInstruction: UILabel!
    @IBOutlet var emailSecondaryInstruction: UILabel!
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUIInitialModifications()
        addGesturesToViews()
    }
    
    //MARK: - Logic
    /**
     Add tapped gestures to the views
     */
    func addGesturesToViews() {
        cellphoneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellphoneTapped)))
        emailView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(emailTapped)))
    }
    
    //MARK: - Actions
    
    //MARK: - Objective C functions
    /**
     Action when the Face Authentication is tapped
     */
    @objc func cellphoneTapped() {
        if UserDefaults.standard.canUseSMSTokenAuthentication && UserDefaults.standard.canUseSMSTokenDM {
            let enterTokenVC = EnterTokenViewController.instantiateFromAppStoryboard(appStoryboard: .token)
            enterTokenVC.isEmail = false
            navigationController?.pushViewController(enterTokenVC, animated: true)
        }
    }
    
    /**
     Action when the Token Authentication is tapped
     */
    @objc func emailTapped() {
        if UserDefaults.standard.canUseEmailTokenAuthentication && UserDefaults.standard.canUseEmailTokenDM {
            let enterTokenVC = EnterTokenViewController.instantiateFromAppStoryboard(appStoryboard: .token)
            enterTokenVC.isEmail = true
            navigationController?.pushViewController(enterTokenVC, animated: true)
        }

    }
    
    //MARK: - UI Modifications
    func createUIInitialModifications() {
        //Add back button
        self.addCustomBackButton()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.customizeWithProfuturoBar(view: extensionView)
        
        //Cards format
        cellphoneView.addCardStyle()
        emailView.addCardStyle()
        
        //Add the user data to the labels
        let maskedNumber = UserDefaults.standard.userInformation.phoneNumber.maskPhone()
        cellphoneNumberToSend.text = "Código vía celular\n\(maskedNumber)"
        
        let maskedEmail = UserDefaults.standard.userInformation.email.maskEmail()
        emailToSend.text = "Código vía correo electrónico\n\(maskedEmail)"
        
        //Block authentication ways from user permissions
        var canUseSMS = UserDefaults.standard.canUseSMSTokenAuthentication
        var canUseEmail = UserDefaults.standard.canUseEmailTokenAuthentication
        
        // New Validation edit data in progress
        if (!UserDefaults.standard.canUseSMSTokenDM) {
            canUseSMS = false
        }
        if (!UserDefaults.standard.canUseEmailTokenDM) {
            canUseEmail = false
        }
        //SMS card
        blockedCellphoneView.isHidden = canUseSMS
        cellphoneNumberToSend.textColor = canUseSMS ? UIColor(named: "NavyBlue") : UIColor(named: "IntentGray")
        smsSecondaryInstruction.textColor = canUseSMS ? UIColor(named: "GrayText") : UIColor(named: "IntentGray")
        smsTokenImage.image = canUseSMS ? UIImage(named: "password") : UIImage(named: "passwordGray")
        
        //Email card
        blockedEmailView.isHidden = canUseEmail
        emailToSend.textColor = canUseEmail ? UIColor(named: "NavyBlue") : UIColor(named: "IntentGray")
        emailSecondaryInstruction.textColor = canUseEmail ? UIColor(named: "GrayText") : UIColor(named: "IntentGray")
        emailTokenImage.image = canUseEmail ? UIImage(named: "password") : UIImage(named: "passwordGray")
        
        let hasSMSAttempts = UserDefaults.standard.hasDailyAttemptsOfSMS
        let hasEmailAttempts = UserDefaults.standard.hasDailyAttemptsOfEmail
        
        smsSecondaryInstruction.text = hasSMSAttempts ? "Recibirás un código de 6 dígitos en tu\nnúmero celular" : "Has excedido el número de intentos,\nvuelve a intentarlo en 24 hrs."
        emailSecondaryInstruction.text = hasEmailAttempts ? "Recibirás un código de 6 dígitos en tu\ncorreo electrónico" : "Has excedido el número de intentos,\nvuelve a intentarlo en 24 hrs."
        // New Validation edit data in progress
        if (!UserDefaults.standard.canUseSMSTokenDM) {
            smsSecondaryInstruction.text = "Tienes una Modificación de Datos en proceso.\n Para continuar, elige otra opción para autenticarte."
        }
        if (!UserDefaults.standard.canUseEmailTokenDM) {
            emailSecondaryInstruction.text = "Tienes una Modificación de Datos en proceso.\n Para continuar, elige otra opción para autenticarte."
        }
    }
}

//MARK: - UIGestureRecognizerDelegate
extension SelectTokenWayViewController: UIGestureRecognizerDelegate { }

