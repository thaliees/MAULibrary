//
//  AuthenticationErrorViewController.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 27/01/21.
//

import UIKit

class AuthenticationErrorViewController: UIViewController {
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction func tryAgainTapped(_ sender: UIButton) {
        dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name(NotificationObserverServices.tryAgainAuthentication.rawValue), object: nil)
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name(NotificationObserverServices.closeMAUDeniedEnterToken.rawValue), object: nil)
    }
}