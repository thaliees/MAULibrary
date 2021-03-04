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
        if UserDefaults.standard.canUseSMSTokenAuthentication {
            let enterTokenVC = EnterTokenViewController.instantiateFromAppStoryboard(appStoryboard: .token)
            enterTokenVC.isEmail = false
            navigationController?.pushViewController(enterTokenVC, animated: true)
        }
    }
    
    /**
     Action when the Token Authentication is tapped
     */
    @objc func emailTapped() {
        if UserDefaults.standard.canUseEmailTokenAuthentication {
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
        blockedCellphoneView.isHidden = UserDefaults.standard.canUseSMSTokenAuthentication
        blockedEmailView.isHidden = UserDefaults.standard.canUseEmailTokenAuthentication
    }
}

//MARK: - UIGestureRecognizerDelegate
extension SelectTokenWayViewController: UIGestureRecognizerDelegate { }

