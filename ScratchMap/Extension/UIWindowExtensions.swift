//
//  UIWindowExtensions.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/19.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit

typealias CrossDissolveCompletion = (Bool) -> Void

// swiftlint:disable variable_name
func crossDissolve(from: UIViewController?, to: UIViewController, completion: CrossDissolveCompletion?) {
    // swiftlint:enable variable_name
    
    guard
        let from = from
        else {
            
            completion?(true)
            
            return
            
    }
    
    let fromView = from.view!
    
    let toView = to.view!
    
    toView.addSubview(fromView)
    
    UIView.animate(
        withDuration: 0.6,
        animations: {
            
            fromView.layer.opacity = 0.0
            
    },
        completion: { isComplete in
            
            fromView.removeFromSuperview()
            
            completion?(isComplete)
            
    }
    )
    
}


extension UIWindow {
    
    typealias UpdateRootCompletion = (Bool) -> Void
    
    typealias UpdateRootAnimation = (_ from: UIViewController?, _ to: UIViewController, _ completion: UpdateRootCompletion?) -> Void
    
    func updateRoot(
        to newViewController: UIViewController,
        animation: UpdateRootAnimation,
        completion: UpdateRootCompletion?
        ) {
        
        let fromViewController = rootViewController
        
        let toViewController = newViewController
        
        rootViewController = toViewController
        
        animation(
            fromViewController,
            toViewController,
            completion
        )
        
    }
    
}
