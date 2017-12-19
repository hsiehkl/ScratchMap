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
                    print(firebaseError.localizedDescription)
                    return
                }
                
                print("login success")
            })
            
            
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
