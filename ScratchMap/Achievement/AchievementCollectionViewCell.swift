//
//  AchievementCollectionViewCell.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/20.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit

class AchievementCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var continentProgressBarView: ProgressBarView!
    @IBOutlet weak var baseView: UIView!
    
//    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var continentPercentageLabel: UILabel!
    
    @IBOutlet weak var continentLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 20
        
        imageView.clipsToBounds = true
 
        imageView.layer.shadowColor = UIColor.gray.cgColor
        
        imageView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        
        imageView.layer.shadowOpacity = 0.5

        imageView.layer.shadowRadius = 2.0
        
        baseView.layer.cornerRadius = 10
        
        
    }

}

