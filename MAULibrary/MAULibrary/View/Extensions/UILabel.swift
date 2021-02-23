//
//  UILabel.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 12/01/21.
//

import UIKit

extension UILabel {
    
    /**
     Adds spacing to a UILabel
     */
    func setTextSpacingBy(value: Double) {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: value, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
