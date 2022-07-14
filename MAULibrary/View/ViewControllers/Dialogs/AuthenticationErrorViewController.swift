//
//  AuthenticationErrorViewController.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 27/01/21.
//

import UIKit

class AuthenticationErrorViewController: UIViewController {
    
    //UI Properties
    @IBOutlet var tryAgainButton: UIButton!
    
    //Logic Properties
    /// Observer to call when the error screen show
    var observerToCall: NotificationObserverServices!
    var observerToCallClose: NotificationObserverServices!
    var showTryAgainButton: Bool!
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide button if the user don't have more authentication methods
        tryAgainButton.isHidden = !showTryAgainButton
    }
    
    //MARK: - Actions
    @IBAction func tryAgainTapped(_ sender: UIButton) {
        dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name(observerToCall.rawValue), object: nil)
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name(observerToCallClose.rawValue), object: nil)
    }
}
