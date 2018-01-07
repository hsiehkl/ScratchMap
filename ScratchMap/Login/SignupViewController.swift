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
    
    @IBOutlet weak var backToLoginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
        setupTextField()
        
    }
    
    @IBAction func signupAction(_ sender: Any) {
        
        if
            (emailTextField.text?.isEmpty)!
        {
            
            self.showAlert(title: "Opps!", message: "Please fill in all blanks.", handler: nil)
            
            return
        }
        
        if
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let userName = userNameTextField.text
        
        {

            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if let firebaseError = error {
                    
                    self.showAlert(title: "Opps!", message: "\(firebaseError.localizedDescription)", handler: nil)
                    
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
    
    // setup components
    
    private func setupTextField() {
        
        emailTextField.layer.cornerRadius = 8
        userNameTextField.layer.cornerRadius = 8
        passwordTextField.layer.cornerRadius = 8
        
        emailTextField.layer.shadowColor = UIColor.gray.cgColor
        userNameTextField.layer.shadowColor = UIColor.gray.cgColor
        passwordTextField.layer.shadowColor = UIColor.gray.cgColor
        
        emailTextField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        userNameTextField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        passwordTextField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        
        emailTextField.layer.shadowOpacity = 0.5
        userNameTextField.layer.shadowOpacity = 0.5
        passwordTextField.layer.shadowOpacity = 0.5
        
        emailTextField.layer.shadowRadius = 2.0
        userNameTextField.layer.shadowRadius = 2.0
        passwordTextField.layer.shadowRadius = 2.0
        
    }
    
    private func setupButton() {
        
        signupButton.layer.cornerRadius = 8
        
    }
    
    deinit {
        print("sign up controller")
    }
    
}
