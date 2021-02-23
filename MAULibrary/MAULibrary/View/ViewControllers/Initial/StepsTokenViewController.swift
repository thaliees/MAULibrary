//
//  StepsTokenViewController.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 07/01/21.
//

import UIKit

class StepsTokenViewController: UIViewController {
     
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    /**
     Action when the close button is tapped
     */
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
