//
//  ContactInformationViewController.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 17/12/20.
//

import UIKit

class ContactInformationViewController: UIViewController {
    
    //MARK: - UI Properties
    @IBOutlet var cdmxPhone: UIImageView!
    @IBOutlet var internalPhone: UIImageView!
    
    //MARK: - Logic Properties
    private let presenter = ContactInfromationPresenter()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setViewDelegate(contactInformationDelegate: self)
        
        addGesturesToViews()
    }
    
    //MARK: - Logic
    /**
     Add tapped gestures to the views
     */
    private func addGesturesToViews() {
        cdmxPhone.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cdmxPhoneTapped(tapGestureRecognizer:))))
        internalPhone.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(interiorPhoneTapped(tapGestureRecognizer:))))
    }
    
    //MARK: - Objective C functions
    /**
     Action when the Facial question mark is tapped
     */
    @objc private func cdmxPhoneTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        presenter.callCDMXPhone()
    }
    
    /**
     Action when the Facial question mark is tapped
     */
    @objc private func interiorPhoneTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        presenter.callInteriorPhone()
    }
    
    //MARK: - Actions
    /**
     Action when the close button is tapped
     */
    @IBAction private func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

//MARK: - ContactInformationDelegate
extension ContactInformationViewController: ContactInformationDelegate { }
