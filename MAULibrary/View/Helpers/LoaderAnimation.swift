//
//  Animations.swift
//  MAULibrary
//
//  Created by Ángel Eduardo Domínguez Delgado on 18/01/21.
//

import UIKit
import Lottie

/**
 Animation for the loader that shows when a connection to internet is called
 */
class LoaderAnimation {
    var animationView: AnimationView?
    var primaryAnimationView: UIView!
    
    init() {
        primaryAnimationView = UIView()
        primaryAnimationView.frame = UIApplication.shared.windows.first!.bounds
        primaryAnimationView.backgroundColor = .white
        animationView = .init(name: "profuturoAnimation")
        animationView?.frame = UIApplication.shared.windows.first!.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 1
        primaryAnimationView.addSubview(animationView!)
    }
    
    /**
     Shows the loader view on top of the window
     */
    func showLoaderView() {
        animationView?.play()
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(primaryAnimationView)
    }
    
    /**
     Removes the loader view from top of the window
     */
    func hideLoaderView() {
        animationView?.stop()
        primaryAnimationView.removeFromSuperview()
    }
    
    /**
     Plays the animation of the loader
     */
    func playAnimation() {
        animationView?.play()
    }
    
    /**
     Stops the animation of the loader
     */
    func stopAnimation() {
        animationView?.stop()
    }
}


