//
//  NewsFeedTableViewCell.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/10.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextField: UITextView!
    @IBOutlet weak var editingButton: UIButton!
    
    @IBAction func testButton(_ sender: Any) {
        
        print("I tapped the button!")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        
        button.backgroundColor = UIColor.black
        
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        setupPhotoImageView()
        self.contentView.addSubview(button)
        
        
//        editingButton.subviews[0].isUserInteractionEnabled = false

    }
    
    @objc func buttonTapped() {
        
        print("~~~~~~~~~~~~~~~~~~~~")
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//    }
    
    func setupPhotoImageView() {
        
        self.postImageView.tintColor = UIColor.flatGray
        
        self.postImageView.contentMode = .scaleAspectFill

         self.postImageView.clipsToBounds = true

    }

}
