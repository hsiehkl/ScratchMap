//
//  UINibExtension.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/2.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//

import UIKit

public extension UINib {

    public class func load(nibName name: String, bundle: Bundle? = nil) -> Any? {

        return UINib(nibName: name, bundle: bundle)
            .instantiate(withOwner: nil, options: nil)
            .first
    }

}
