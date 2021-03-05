//
//  LimitExceededViewController.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 24/02/21.
//

import UIKit

class LimitExceededViewController: UIViewController {
    
    //Logic Properties
    /// Observer to call when the error screen show
    var observerToCall: NotificationObserverServices!
 
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    /**
     Action when the close button is tapped
     */
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: false)
        NotificationCenter.default.post(name: Notification.Name(observerToCall.rawValue), object: nil)
    }
}
