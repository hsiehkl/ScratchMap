//
//  AchievementCollectionViewCell.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/20.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit

class AchievementCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var continentImageView: UIImageView!
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var continentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.gray
        
    }

}

