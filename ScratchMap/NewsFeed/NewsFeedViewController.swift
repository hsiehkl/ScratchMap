//
//  NewsFeedViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/10.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseStorage

class NewsFeedViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var visitedCountries = [Country]()
    private let postProvider = PostProvider()
    var posts = [Post]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postProvider.requestData()
        postProvider.delegate = self
        
        setupNavigationBar()
        let nib = UINib(nibName: "JourneyTableViewCell", bundle: nil)
        
        self.tableView.register(nib, forCellReuseIdentifier: "journeyTableViewCell")
        self.tableView.register(UINib(nibName: "NewsFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "newsFeedTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        catchMainPage()
    }
    
    func setupNavigationBar() {
        
        self.navigationItem.title = "Journeys"
        
        let image = UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal)
        let addButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(publishPost))
        self.navigationItem.rightBarButtonItem = addButton

    }
    
    @objc func publishPost() {
        
        let publishViewController = PublishViewController(nibName: "PublishViewController", bundle: nil)
        
        publishViewController.visitedCountries = self.visitedCountries

        self.present(publishViewController, animated: true, completion: nil)

    }
    
    deinit {
        print("NewsFeedViewController@@@@")
    }
}

extension NewsFeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var numberOfSections = 0
        
        if posts.count > 0 {
            
            tableView.backgroundView = nil
            
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            
            backgroundImageView.image = nil
            
            numberOfSections = 1
            
        } else {
            
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            animation()
        }
        
        return numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "journeyTableViewCell", for: indexPath) as! JourneyTableViewCell
        
        if let imageURL = URL(string: self.posts[indexPath.row].imageUrl) {

            DispatchQueue.main.async {
                cell.postImageView.sd_setImage(with: imageURL)
            }
        }
        
        cell.editingButton.addTarget(self, action: #selector(editPost(_:)), for: .touchUpInside)

        cell.titleLabel.text = posts[indexPath.row].title
        cell.contentLabel.text = posts[indexPath.row].content
//        cell.dateLabel.text = posts[indexPath.row].date
        cell.locationLabel.text = "@\(posts[indexPath.row].location)"
        
        let date = DateConverter.convertDownloadDate(date: posts[indexPath.row].date)
        cell.dateLabel.text = date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        
//        if editingStyle == .delete {
//            
//            let alertController = UIAlertController(title: NSLocalizedString("Notice!", comment: ""), message: NSLocalizedString("This post will be deleted.", comment: ""), preferredStyle: .alert)
//            
//            alertController.addAction(UIAlertAction(title:NSLocalizedString("Confirm", comment: ""), style: .default, handler: { (_) in
//                
//                let userId = Auth.auth().currentUser?.uid
//                
//                guard let id = userId else { return }
//                
//                let ref = Database.database().reference()
//                
//                let postReference = ref.child("users").child(id).child("posts").child(self.posts[indexPath.row].countryId).child(self.posts[indexPath.row].postId)
//                postReference.removeValue()
//                
//                
//                print("before!!\(self.posts.count)")
//                self.posts.remove(at: indexPath.row)
//                print("after!!\(self.posts.count)")
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            }))
//            
//            alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
//            
//            self.present(alertController, animated: true, completion: nil)
//        }
//    }
    
    func animation() {
        
        backgroundImageView.image = UIImage(named: "backgroundLight")
        
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        let font = UIFont(name: "Avenir-Medium", size: 18)
        noDataLabel.font = font
        noDataLabel.text = NSLocalizedString("Adventure awaits!", comment: "")
        noDataLabel.textColor = UIColor.black
        noDataLabel.textAlignment = .center
        
        let waterView = WaveView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 50), color: UIColor.white)
        
        waterView.backgroundColor = UIColor.clear
        
        waterView.addOverView(noDataLabel)
        
        tableView.backgroundView = waterView
        
        waterView.start()
    }
    
    @objc func editPost(_ sender: UIButton) {
        print("here")
        print("here")
        
        guard
            
            let tableView = self.tableView,
            let cell = sender.superview?.superview?.superview as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell)
            else {
                print("There is no correct index")
                return
        }
        
        print("got it!!!!\(indexPath)")
        
    }
    
    func catchMainPage() {
        
        if let mainPageVC = self.tabBarController?.viewControllers?[0] as? MainPageViewController {
            
            self.visitedCountries = mainPageVC.visitedCountries

        }
    }

}

extension NewsFeedViewController: PostProviderDelegate {
    
    func didReceivePost(_ provider: PostProvider, posts: [Post]) {
        
        print("self.posts.count1111: \(self.posts.count)")
//        self.posts.removeAll()
        print("self.posts.count2222: \(self.posts.count)")
        self.posts = posts
        print("self.posts.count2222: \(self.posts.count)")
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
