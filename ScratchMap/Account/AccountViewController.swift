//
//  AccountViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/1.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MessageUI

class AccountViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissSettingView(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func setupNavigationBar() {
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference()
        
        ref.child("users").child(userId).child("userName").observeSingleEvent(of: .value, with: { (snapshot) in
            
            print("snapshot:: \(snapshot)")
            
            guard let userName = snapshot.value as? String else { return }
            
            self.navigationItem.title = "Setting"
        })
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
        
        if error != nil {
            
            controller.showAlert(title: "Oops!", message: "Email has not been sent. Please try again", handler: { (UIAlertAction) -> Void in
                controller.dismiss(animated: true, completion: nil)
            })
            
        } else {
            
            switch result {
                
                case .sent:
                    controller.showAlert(title: "Thanks!", message: "We will reply you as soon as possible!", handler: { (UIAlertAction) -> Void in
                        controller.dismiss(animated: true, completion: nil)
                })
                
                case .failed:
                    controller.showAlert(title: "Oops!", message: "Email has not been sent. Please try again", handler: { (UIAlertAction) -> Void in
                    controller.dismiss(animated: true, completion: nil)
                })

                default:
                    controller.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        guard let achievementViewController = self.navigationController?.viewControllers[0] as? AchievementViewController else { print("fail here!!!!"); return }
        
        if let mainPageVC = achievementViewController.tabBarController?.viewControllers?[0] as? MainPageViewController {
            
            let imageView = mainPageVC.mapContainerView
            
            let image = UIImage.init(view: imageView)
            
            let imageToShare = [image]
            
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            
            self.present(activityViewController, animated: true, completion: nil)

        }
    }
    
    deinit {
        print("accountViewController@@@@")
    }

}
