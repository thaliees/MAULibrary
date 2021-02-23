//
//  ContactInformationPresenter.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 08/01/21.
//

import Foundation
import UIKit

class ContactInfromationPresenter {
    
    //MARK: - Properties
    weak private var contactInformationDelegate: ContactInformationDelegate?
    
    //MARK: - Init
    func setViewDelegate(contactInformationDelegate: ContactInformationDelegate?) {
        self.contactInformationDelegate = contactInformationDelegate
    }
    
    //MARK: - Logic
    /**
     Open the phone helper to call to CDMX Profuturo's phone
     */
    func callCDMXPhone() {
        if let url = URL(string: "tel://58096555"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    /**
     Open the phone helper to call to Interior republic Profuturo's phone
     */
    func callInteriorPhone() {
        if let url = URL(string: "tel://8007155555"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
