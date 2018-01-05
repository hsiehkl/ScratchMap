//
//  UIImageExtension.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/2.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//

import UIKit

extension UIImage {
    
    convenience init(view: UIView) {
        
        UIGraphicsBeginImageContext(view.bounds.size)
        
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        self.init(cgImage: image!.cgImage!)
    }
}
