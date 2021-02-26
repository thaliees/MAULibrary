//
//  MAU.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 24/02/21.
//

import Foundation

public protocol AuthenticationMAUDelegate {
    func pushViewController<T>(viewController: T)
    func authentication(wasSuccesful: Bool)
}

/**
 Init class to start the MAU
 */
public class MAU {
    
    //MARK: - Init
    public var delegate: AuthenticationMAUDelegate?
    
    public init(delegate: AuthenticationMAUDelegate) {
        self.delegate = delegate
    }
    
    public init() {
        NotificationCenter.default.addObserver(forName: Notification.Name(NotificationObserverServices.authenticationPassed.rawValue), object: nil, queue: nil) { _ in
            self.delegate?.authentication(wasSuccesful: true)
        }
        NotificationCenter.default.addObserver(forName: Notification.Name(NotificationObserverServices.authenticationDenied.rawValue), object: nil, queue: nil) { _ in
            self.delegate?.authentication(wasSuccesful: false)
        }
    }
    
    public func startMAU(userInformation: User) {
        //Save user information
        UserDefaults.standard.userInformation = userInformation
        
        let selectAuthenticationVC = SelectAuthenticationMethodViewController.instantiateFromAppStoryboard(appStoryboard: .initial)
        self.delegate?.pushViewController(viewController: selectAuthenticationVC)
    }
}
