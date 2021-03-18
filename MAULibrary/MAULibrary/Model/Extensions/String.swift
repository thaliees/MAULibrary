//
//  String.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 04/12/20.
//

import Foundation

extension String {
    /**
     Converts the stirng to base64
     */
    func toBase64() -> String {
        let data = self.data(using: .utf8)!
        
        return data.base64EncodedString()
    }
    
    /**
     Masks the first seven digits of a phone number with *
     */
    func maskPhone() -> String {
        if self.count > 0 {
            var chars = Array(self)
            
            for index in 0...6 {
                chars[index] = "*"
            }
            
            return String(chars)
        } else {
            return ""
        }
    }
    
    /**
     Masks the user email with *
     */
    func maskEmail() -> String {
        if self.count > 0 {
            var emailArray = self.components(separatedBy: "@")
            
            let chars = Array(emailArray[0])
            
            var maskedEmail = ""
            
            for index in 0...2 {
                maskedEmail += String(chars[index])
            }
            
            maskedEmail += "*****"
            
            emailArray[0] = maskedEmail
            
            return emailArray.joined(separator: "@")
        } else {
            return ""
        }
    }
}
