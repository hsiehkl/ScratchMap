//
//  NewsFeedViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/10.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import SDWebImage

class NewsFeedViewController: UIViewController {
    
    var navigationTitle = ""
    
    private let postProvider = PostProvider()
    
    var posts = [Post]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postProvider.requestData()
        postProvider.delegate = self
        
        setupNavigationBar()
        let nib = UINib(nibName: "NewsFeedTableViewCell", bundle: nil)
        
        self.tableView.register(nib, forCellReuseIdentifier: "newsFeedTableViewCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupNavigationBar() {
        
        self.navigationItem.title = navigationTitle
        
        let image = UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal)
        let addButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(publishPost))
        self.navigationItem.rightBarButtonItem = addButton
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func publishPost() {
        
        let publishViewController = PublishViewController(nibName: "PublishViewController", bundle: nil)
        
        self.present(publishViewController, animated: true, completion: nil)
        
    }
}

extension NewsFeedViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "newsFeedTableViewCell", for: indexPath) as! NewsFeedTableViewCell
        
//        cell.locationLabel.text = posts[indexPath.row].location
        cell.postTitleLabel.text = posts[indexPath.row].title
//        cell.postImageView.image =  posts[indexPath.row].image
        cell.postTextField.text = posts[indexPath.row].content
        cell.dateLabel.text = posts[indexPath.row].date
        
        if let imageURL = URL(string: self.posts[indexPath.row].imageUrl) {
            
            DispatchQueue.main.async {
                cell.postImageView.sd_setImage(with: imageURL)
            }
        }
        
        return cell
    }
}

extension NewsFeedViewController: PostProviderDelegate {
    
    func didReceivePost(_ provider: PostProvider, posts: [Post]) {
        
        self.posts = posts
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

