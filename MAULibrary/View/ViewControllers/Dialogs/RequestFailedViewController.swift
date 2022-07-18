//
//  RequestFailedViewController.swift
//  MAULibrary
//
//  Created by Thalia Aquino on 06/07/22.
//

import UIKit

class RequestFailedViewController: UIViewController {
    
    //UI Properties
    @IBOutlet weak var message: UILabel!
    
    //Logic Properties
    /// Observer to call when the error screen show
    var observerToCall: NotificationObserverServices!
    public var showError = false
    public var error = ""
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if showError {
            message.text = error
        }
    }
    
    //MARK: - Actions
    /**
     Action when the close button is tapped
     */
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name(observerToCall.rawValue), object: nil)
    }
}
