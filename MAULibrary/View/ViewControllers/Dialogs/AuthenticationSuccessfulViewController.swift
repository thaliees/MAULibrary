//
//  AuthenticationSuccessfulViewController.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 27/01/21.
//

import UIKit

class AuthenticationSuccessfulViewController: UIViewController {
    
    @IBOutlet weak var message: UILabel!
    public var changeText = false
    public var text = ""
    
    //MARK: - Logic Properties
    var observerToCall: NotificationObserverServices!
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if changeText {
            message.text = text
        }
    }
    
    //MARK: - Actions
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name(observerToCall.rawValue), object: nil)
    }
}
