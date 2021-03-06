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
        Database().isPersistenceEnabled = true
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

//    func applicationWillResignActive(_ application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }
//
//    func applicationWillTerminate(_ application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    }

    
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

            let tabBarController = TabBarController(itemTypes: [.map, .achievement])

            return tabBarController

        } else {

            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

            let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController

            return loginViewController
        }

    }

}
