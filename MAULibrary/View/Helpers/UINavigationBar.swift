//
//  UINavigationBar.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 07/01/21.
//

import UIKit

/**
 Customized the navigation bar with the Profuturo colors and image
 */
func customizeNavigationBar(viewController: UIViewController) {
    viewController.navigationItem.titleView = UIImageView(image: UIImage(named: "logoHorizontalProfuturo"))
    viewController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
    viewController.navigationController?.navigationBar.shadowImage = UIImage()
    viewController.navigationController?.navigationBar.layoutIfNeeded()
    viewController.navigationController?.navigationBar.tintColor = UIColor(named: "NavyBlue")
}
