//
//  ContinentDetailTableViewCell.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/5.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//

import UIKit

class ContinentDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var countryFlagImage: UIImageView!
    
    @IBOutlet weak var countryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.layer.cornerRadius = 10
        
        countryFlagImage.layer.shadowColor = UIColor.gray.cgColor
        
        countryFlagImage.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        
        countryFlagImage.layer.shadowOpacity = 0.8
        
        countryFlagImage.layer.shadowRadius = 2
        
        countryFlagImage.layer.cornerRadius = countryFlagImage.bounds.width / 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
