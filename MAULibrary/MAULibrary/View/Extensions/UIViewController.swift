//
//  UIViewController.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 05/01/21.
//

import UIKit

extension UIViewController {
    
    static var storyboardID: String {
        return "\(self)"
    }
    
    /**
     Instantiates a ViewController from the Storyboard selected
     */
    static func instantiateFromAppStoryboard(appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    /**
     Resets the custom navigation bar to  default
     */
    func resetNavigationBarCustomization() {
        navigationItem.titleView = nil
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.layer.shadowColor = nil
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        navigationController?.navigationBar.layer.shadowRadius = 0.0
        navigationController?.navigationBar.layer.shadowOpacity = 0.0
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationItem.rightBarButtonItem = nil
        navigationController?.navigationBar.backIndicatorImage = nil
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = nil
    }
    
    /**
     Customize the navigation bar with the profuturo style and add a shadow at the bottom of the view
     */
    func customizeWithProfuturoBar(view: UIView) {
        //Navigation Bar
        customizeNavigationBar(viewController: self)
        
        //Add shadow to banner
        view.addBottomShadow()
    }
    
    /**
     Add a custom back button with the Profuturo colors
     */
    func addCustomBackButton() {
        //Add back button
        let backButtonItem = UIBarButtonItem(image: UIImage(named: "backArrow")?.withInsets(UIEdgeInsets(top: 5.0, left: 10.0, bottom: 0, right: 0)), style: .plain, target: navigationController, action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backButtonItem
        
        //NavBar
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
}
