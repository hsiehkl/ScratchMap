//
//  AccountViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/1.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import FirebaseAuth
import MessageUI

class AccountViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissSettingView(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func setupNavigationBar() {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        button.tintColor = UIColor.black
//        button.addTarget(self, action: #selector(presentSettingpage), for: .touchUpInside)
        let cancelButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    @IBAction func logout(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
        
        } catch let signOutError as NSError {
        
            self.showAlert(title: "Oops!", message: "\(signOutError)")
        
            print ("Error signing out: %@", signOutError)
        }
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        
        self.dismiss(animated: true, completion: nil)
        
        AppDelegate.shared.window?.updateRoot(
            to: loginViewController,
            animation: crossDissolve,
            completion: nil
        )
    }
    
    @IBAction func sendEmailButtonTapped(_ sender: Any) {
        
        if !MFMailComposeViewController.canSendMail() {
            
            self.showAlert(title: "Oops!", message: "Mail services currently are not available.")
            
        } else {
            
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self
            
            composeViewController.setToRecipients(["st4465@gmail.com"])
            composeViewController.setSubject("Map Feedback")
            composeViewController.setMessageBody("Hello!", isHTML: false)
            
            self.present(composeViewController, animated: true, completion: nil)
            
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("accountViewController@@@@")
    }

}
