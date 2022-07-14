//
//  LimitExceededTryAnotherViewController.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 24/02/21.
//

import UIKit

class LimitExceededTryAnotherViewController: UIViewController {
    
    //Logic Properties
    /// Observer to call when the error screen show
    var observerToCall: NotificationObserverServices!
    var closeObserverToCall: NotificationObserverServices!
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction func tryAgainTapped(_ sender: UIButton) {
        dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name(observerToCall.rawValue), object: nil)
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name(closeObserverToCall.rawValue), object: nil)
    }
}
