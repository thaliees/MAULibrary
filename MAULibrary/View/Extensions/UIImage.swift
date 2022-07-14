//
//  UIImage.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 20/01/21.
//

import UIKit

extension UIImage {
    /**
     Add insets to a UIImage, used for the back button of athe navigation bar
     */
    func withInsets(_ insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: size.width + insets.left + insets.right,
                   height: size.height + insets.top + insets.bottom),
            false,
            self.scale)
        
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageWithInsets
    }
}
