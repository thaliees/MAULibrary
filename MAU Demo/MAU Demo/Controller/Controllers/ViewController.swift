//
//  ViewController.swift
//  MAU Demo
//
//  Created by Ángel Eduardo Domínguez Delgado on 09/03/21.
//

import UIKit
import MAULibrary

class ViewController: UIViewController {
    
    @IBOutlet var colorBox: UIView!
    @IBOutlet var authorizationStatus: UILabel!
    @IBOutlet var curpField: UITextField!
    @IBOutlet var processIDField: UITextField!
    @IBOutlet var subprocessIDField: UITextField!
    @IBOutlet var originIDField: UITextField!
    
    let mau = MAU()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add delegates to text fields
        curpField.delegate = self
        processIDField.delegate = self
        subprocessIDField.delegate = self
        originIDField.delegate = self
    }
    
    @IBAction func openMAUTapped(_ sender: UIButton) {
        
        let curp = curpField.text ?? ""
        let processID = processIDField.text ?? ""
        let subprocessID = subprocessIDField.text ?? ""
        let originID = originIDField.text ?? ""

        let userInformation = User.init(
            name: "Ángel Eduardo",
            lastName: "Domínguez",
            mothersLastName: "Delgado",
            client: "0",
            account: "0",
            curp: curp == "" ? "DODA961018HVZMLN06" : curp,
            processID: processID == "" ? 226 : Int(processID)!,
            subProcessID: subprocessID == "" ? 405 : Int(processID)!,
            originID: originID == "" ? 34 : Int(originID)!)
        mau.delegate = self

        mau.startMAU(userInformation: userInformation)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

//MARK: - AuthenticationMAUDelegate
extension ViewController: AuthenticationMAUDelegate {
    public func pushViewController<T>(viewController: T) {
        if let selectAuthenticationMethodVC = viewController as? SelectAuthenticationMethodViewController {
            navigationController?.pushViewController(selectAuthenticationMethodVC, animated: true)
        }
    }

    public func authentication(wasSuccesful: Bool) {
        if wasSuccesful {
            colorBox.backgroundColor = .systemGreen
            authorizationStatus.text = "Autenticación exitosa"
        } else {
            colorBox.backgroundColor = .systemRed
            authorizationStatus.text = "Autenticación fallida"
        }
    }
}

//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {}



