//
//  ConnectionErrorViewController.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 26/01/21.
//

import UIKit

class ConnectionErrorViewController: UIViewController {
    
    //UI Properties
    @IBOutlet var message: UILabel!
    
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
