//
//  InstructionsFacialDelegate.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 04/03/21.
//

import Foundation

protocol InstructionsFacialDelegate: BaseDelegate {
    func showFacialAttempts()
    func showAuthenticationSuccesful()
    func showErrorMessage(error: String)
    func failedRequest()
}
