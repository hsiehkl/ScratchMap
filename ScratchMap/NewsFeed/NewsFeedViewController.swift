//
//  NewsFeedViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/10.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController {
    
    let posts: [Post] = [Post(title: "1", location: "@Taipei, Taiwan", image: UIImage(named: "Europe-1")!, content: "goodfasddsfsdfhdkjvsdoifjoisdjfoisajdfoiasdjfiosjdfoijdsfojdsoifjdisojfodisjfiosjdfoisjdfkxnckdsnifdnsfindinvidsnvifdnijsdfoasjdfkncvasdfsdafsdfsdfsadfasdfcdsfesdcdsfsadcvsdfsdfcdsfgdsvesrfesdvxfwesdfdsxfsdfxvfdsfsdnvifsdjfnvnndisnfisdjflknvsdnofjdsifjo"), Post(title: "2", location: "@Taoyuan, Taiwan", image: UIImage(named: "Asia-1")!, content: "soso")]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "NewsFeedTableViewCell", bundle: nil)
        
        self.tableView.register(nib, forCellReuseIdentifier: "newsFeedTableViewCell")

        
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
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 518
//    }
}

