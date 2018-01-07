//
//  UIViewExtension.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/25.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit

public extension UIView {

    public class func load(nibName name: String, bundle: Bundle? = nil) -> UIView? {

        return UINib.load(nibName: name, bundle: bundle) as? UIView

    }

}
