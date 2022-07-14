//
//  TokenPreInformationViewController.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 07/01/21.
//

import UIKit

class TokenPreInformationViewController: UIViewController {
    
    //MARK: - UI Properties
    @IBOutlet var extensionView: UIView!
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUIInitialModifications()
    }
    
    //MARK: - UI Modifications
    /**
     Adds initial modifications to the UI (like back buttons, navigation bar)
     */
    func createUIInitialModifications() {
        //Add back button
        self.addCustomBackButton()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.customizeWithProfuturoBar(view: extensionView)
    }
    
    //MARK: - Actions
    /**
     Action when the continue button is tapped
     */
    @IBAction func continueTapped(_ sender: UIButton) {
        let selectTokenWayVC = SelectTokenWayViewController.instantiateFromAppStoryboard(appStoryboard: .token)
        navigationController?.pushViewController(selectTokenWayVC, animated: true)
    }
}

//MARK: - UIGestureRecognizerDelegate
extension TokenPreInformationViewController: UIGestureRecognizerDelegate { }
