//
//  SignupViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/19.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignupViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupAction(_ sender: Any) {
        
        if
            (emailTextField.text?.isEmpty)!
        {
            let alertController = UIAlertController(
                title: "Oops!",
                message: "Please fill in an user name.",
                preferredStyle: UIAlertControllerStyle.alert
            )
            
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        if
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let userName = userNameTextField.text
        
        {

            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
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

                guard let userId = user?.uid else {
                    // need to handle
                    return
                }
                
                let ref = Database.database().reference().child("users").child(userId)
                let value = ["userName": userName]
                ref.setValue(value)
                
                print("signup success!")
                self.dismiss(animated: true, completion: nil)
                
            })
        } else {
            
        }
    }
    @IBAction func backToLoginAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
