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
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField()
        setupButton()
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
                    
                    self.showAlert(title: "Oops!", message: "\(firebaseError.localizedDescription)", handler: nil)
                    
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

                print("login success")
            })
            
            
        } else {
            
        }
    }
    
    // setup components
    
    private func setupTextField() {
        
        emailTextField.layer.cornerRadius = 8
        passwordTextField.layer.cornerRadius = 8
        
        emailTextField.layer.shadowColor = UIColor.gray.cgColor
        passwordTextField.layer.shadowColor = UIColor.gray.cgColor
        
        emailTextField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        passwordTextField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        
        emailTextField.layer.shadowOpacity = 0.5
        passwordTextField.layer.shadowOpacity = 0.5
        
        emailTextField.layer.shadowRadius = 2.0
        passwordTextField.layer.shadowRadius = 2.0
        
    }
    
    private func setupButton() {
        
        loginButton.layer.cornerRadius = 8

    }
    
    
    
}
