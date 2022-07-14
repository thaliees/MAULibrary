//
//  BaseDelegate.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 26/01/21.
//

import Foundation

protocol BaseDelegate: NSObjectProtocol {
    func showLoader()
    func hideLoader()
    func showConnectionErrorMessage()
}
