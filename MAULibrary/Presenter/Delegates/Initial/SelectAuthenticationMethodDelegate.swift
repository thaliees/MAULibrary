//
//  SelectAuthenticationMethodDelegate.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 05/01/21.
//

import Foundation

protocol SelectAuthenticationMethodDelegate: BaseDelegate {
    func setAuthenticationMethodsFromCriticality()
    func showAuthenticationSuccessful()
}
