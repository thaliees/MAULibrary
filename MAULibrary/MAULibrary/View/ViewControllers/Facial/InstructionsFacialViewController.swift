//
//  InstructionsFacialViewController.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 12/01/21.
//

import UIKit

class InstructionsFacialViewController: UIViewController {
    
    //MARK: - UI Properties
    @IBOutlet var extensionView: UIView!
    
    //MARK: - Logic Properties
    var mauDelegate: AuthenticationMAUDelegate?
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createUIInitialModifications()
    }
    
    //MARK: - Actions
    /**
     Action when the continue button is tapped
     */
    @IBAction func continueTapped(_ sender: UIButton) {
    }
    
    //MARK: - UI Modifications
    /**
     Adds initial modifications to the UI (like back buttons, navigation bar)
     */
    func createUIInitialModifications() {
        //Reset custom navigation bar
        self.resetNavigationBarCustomization()
        
        //Add back button
        self.addCustomBackButton()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.customizeWithProfuturoBar(view: extensionView)
    }
}

//MARK: - UIGestureRecognizerDelegate
extension InstructionsFacialViewController: UIGestureRecognizerDelegate { }
