//
//  AppDelegate.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/15.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var orientation: UIInterfaceOrientation = .portrait

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Setup Firebase

        FirebaseApp.configure()
//        Database().isPersistenceEnabled = true
        let queue = DispatchQueue.global()
        Database.database().callbackQueue = queue

        // Setup TabBarController

        let entryViewController = makeEntryController()

        let window = UIWindow(frame: UIScreen.main.bounds)

        window.rootViewController = entryViewController

        window.makeKeyAndVisible()

        self.window = window

        // IQKeyboardManager

        IQKeyboardManager.sharedManager().enable = true

        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if let rootViewController = self.topViewControllerWithRootViewController(rootViewController: window?.rootViewController) {
            
            if (rootViewController.responds(to: Selector(("canRotate")))) {
                
                return .allButUpsideDown
            }
        }
        
        return .portrait
    }
    
    private func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
        
        if (rootViewController == nil) { return nil }
        
        if (rootViewController is (UITabBarController)) {
            
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UITabBarController).selectedViewController)
            
        } else if (rootViewController is (UINavigationController)) {
            
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UINavigationController).visibleViewController)
            
        } else if (rootViewController.presentedViewController != nil) {
            
            return topViewControllerWithRootViewController(rootViewController: rootViewController.presentedViewController)
        }
        
        return rootViewController
    }

    func makeEntryController() -> UIViewController {

        if Auth.auth().currentUser != nil {

            let tabBarController = TabBarController(itemTypes: [.map, .achievement, .journey])

            return tabBarController

        } else {

            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

            let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") //as! LoginViewController

            return loginViewController
        }

    }

}
