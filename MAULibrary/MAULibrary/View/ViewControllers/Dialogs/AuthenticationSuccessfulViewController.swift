//
//  AuthenticationSuccessfulViewController.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 27/01/21.
//

import UIKit

class AuthenticationSuccessfulViewController: UIViewController {
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction func closeTapped(_ sender: UIButton) {
        #if DEBUG
        exit(0)
        #endif
    }
}
