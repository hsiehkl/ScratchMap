//
//  TabBarItem.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/16.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import Foundation
import UIKit

class TabBarItem: UITabBarItem {

    // MARK: Property

    var itemType: TabBarItemType?

    // MARK: Init

    init(itemType: TabBarItemType) {

        super .init()

        self.itemType = itemType

        self.title = itemType.title

        self.image = itemType.image
        
        self.selectedImage = itemType.selectedImage
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

    }

}

