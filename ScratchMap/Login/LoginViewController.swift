//
//  LoginViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/19.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func createAccountAction(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let signupViewController = storyboard.instantiateViewController(withIdentifier: "signupViewController") as! SignupViewController

        self.present(signupViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if let firebaseError = error {
                    
                    let alertController = UIAlertController(
                        title: "Oops!",
                        message: "\(firebaseError.localizedDescription)",
                        preferredStyle: UIAlertControllerStyle.alert
                    )
                    
                    alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

                    self.present(alertController, animated: true, completion: nil)
                    
                    print(firebaseError.localizedDescription)
                    return
                }
                
                let tabBarController = TabBarController(
                    itemTypes: [ .map, .achievement ]
                )
                
                AppDelegate.shared.window?.updateRoot(
                    to: tabBarController,
                    animation: crossDissolve,
                    completion: nil
                )
                
//                let window = UIWindow(frame: UIScreen.main.bounds)
//
//                AppDelegate.shared.window?.rootViewController = tabBarController
//
//                window.makeKeyAndVisible()
//
//                self.window = window

                print("login success")
            })
            
            
        } else {
            
        }
    }
    
/* log out

     func logoutAction() {
     
     do {
        try Auth.auth()?.signOut()
     } catch {
        print("logout problem")
     }
     
     
     }
     
     
*/
}
