//
//  NewsFeedTableViewCell.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/10.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextField: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupPhotoImageView()
        
//        postImageView.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupPhotoImageView() {
        
        self.postImageView.tintColor = UIColor.flatGray
        
        self.postImageView.contentMode = .center
        
//        self.postImageView.image = #imageLiteral(resourceName: "icon-photo").withRenderingMode(.alwaysTemplate)
        
//        self.postImageView.layer.cornerRadius = 8
        
//        self.postImageView.clipsToBounds = true
        
//        self.postImageView.layer.shadowOpacity = 1
//        
//        self.postImageView.layer.shadowOffset = CGSize.zero
//        
//        self.postImageView.layer.shadowRadius = 20
//        
//        self.postImageView.layer.shadowColor = UIColor.flatGray.cgColor
//        
//        self.postImageView.layer.masksToBounds = true
//        
//        self.postImageView.layer.shadowPath = UIBezierPath(rect: postImageView.bounds).cgPath
    }
    
}
