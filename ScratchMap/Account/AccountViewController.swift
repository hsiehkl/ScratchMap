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
import ChameleonFramework
import Crashlytics

class AccountViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()

        self.navigationItem.title = "Setting"

    }

    @IBAction func dismissSettingView(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)

    }

    func setupNavigationBar() {

        guard let userId = Auth.auth().currentUser?.uid else { return }

        let ref = Database.database().reference()

        ref.child("users").child(userId).child("userName").observeSingleEvent(of: .value, with: { (snapshot) in

            guard let userName = snapshot.value as? String else { return }

            self.userNameLabel.text = "Hi! \(userName)"

        })
    }

    @IBAction func logout(_ sender: Any) {

        let alertController = UIAlertController(title: "Hey!", message: "You are going to logout.", preferredStyle: UIAlertControllerStyle.alert)

        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in

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

        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alertController, animated: true, completion: nil)

    }

    @IBAction func sendEmailButtonTapped(_ sender: Any) {

        if !MFMailComposeViewController.canSendMail() {

            self.showAlert(title: "Oops!", message: "Mail services currently are not available.")

        } else {

            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self

            composeViewController.setToRecipients(["iosscratchmapapp@gmail.com"])
            composeViewController.setSubject("Map Feedback")
            composeViewController.setMessageBody("Hello!", isHTML: false)

            self.present(composeViewController, animated: true, completion: nil)

        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        if error != nil {

            controller.showAlert(title: "Oops!", message: "Email has not been sent. Please try again", handler: { (_) -> Void in
                controller.dismiss(animated: true, completion: nil)
            })

        } else {

            switch result {

                case .sent:
                    controller.showAlert(title: "Thanks!", message: "We will reply you as soon as possible!", handler: { (_) -> Void in
                        controller.dismiss(animated: true, completion: nil)
                })

                case .failed:
                    controller.showAlert(title: "Oops!", message: "Email has not been sent. Please try again", handler: { (_) -> Void in
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
