//
//  AppStoryboard.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 05/01/21.
//

import UIKit

/**
 Helper enum to map the viewcontrollers and storyboards of the application
 */
enum AppStoryboard: String {
    case initial = "Initial"
    case token = "Token"
    case facial = "Facial"
    case dialogs = "Dialogs"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}
