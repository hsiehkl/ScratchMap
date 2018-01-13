//
//  NewsFeedViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/10.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController {
    
    var navigationTitle = ""
    
    let posts: [Post] = [Post(title: "Best trip ever", location: "@Taipei, Taiwan", image: UIImage(named: "Europe-1")!, content: "goodfasddsfsdfhdkjvsdoifjoisdjfoisajdfoiasdjfiosjdfoijdsfojdsoifjdisojfodisjfiosjdfoisjdfkxnckdsnifdnsfindinvidsnvifdnijsdfoasjdfkncvasdfsdafsdfsdfsadfasdfcdsfesdcdsfsadcvsdfsdfcdsfgdsvesrfesdvxfwesdfdsxfsdfxvfdsfsdnvifsdjfnvnndisnfisdjflknvsdnofjdsifjo"), Post(title: "I love Taoyuan", location: "@Taoyuan, Taiwan", image: UIImage(named: "Asia-1")!, content: "sosodfsadfsdfasdfasdfasdfsdfasdfdasfasdf")]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
//        let button = UIButton(type: .system)
//        button.setImage(#imageLiteral(resourceName: "icon_plus"), for: .normal)
//        button.tintColor = UIColor.black
//        button.addTarget(self, action: #selector(publishPost), for: .touchUpInside)
//        let settingButton = UIBarButtonItem(customView: button)
//        self.navigationItem.rightBarButtonItem = settingButton
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
        
        cell.locationLabel.text = posts[indexPath.row].location
        cell.postTitleLabel.text = posts[indexPath.row].title
        cell.postImageView.image =  posts[indexPath.row].image
        cell.postTextField.text =  posts[indexPath.row].content
        
        return cell
    }
}

