//
//  EnterTokenDelegate.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 26/01/21.
//

import Foundation

protocol EnterTokenDelegate: BaseDelegate {
    func showAuthenticationSuccesful()
    func showAuthenticationError()
    func showLimitExceeded()
}
