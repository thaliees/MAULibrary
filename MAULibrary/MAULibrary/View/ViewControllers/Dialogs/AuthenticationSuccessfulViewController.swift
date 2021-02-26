//
//  AuthenticationSuccessfulViewController.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 27/01/21.
//

import UIKit

class AuthenticationSuccessfulViewController: UIViewController {
    
    //MARK: - Logic Properties
    var mauDelegate: AuthenticationMAUDelegate?
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name(NotificationObserverServices.closeMAUPassedEnterToken.rawValue), object: nil)
    }
}
