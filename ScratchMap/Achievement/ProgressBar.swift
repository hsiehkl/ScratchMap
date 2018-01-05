//
//  ProgressBar.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/3.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

class ProgressBarView: UIView {
    
//    var color: UIColor = UIColor(red: 89/255.0, green: 131/255.0, blue: 146/255.0, alpha:1)
//    var color: UIColor = UIColor(red: 255/255.0, green: 191/255.0, blue: 202/255.0, alpha:1)
//    var color: UIColor = UIColor(red: 224/255.0, green: 122/255.0, blue: 95/255.0, alpha:1)
    
    var color: UIColor = FlatTeal()

    var progress: CGFloat = 0.0 {
        
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
        setup()
    }
    
    func setup() {
        self.backgroundColor = color.withAlphaComponent(0.4)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        var progress = self.progress
        
        print("why no corner~~~ \(self.frame.height/2)")
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
        
        let margin:CGFloat = 1
        
        print("progress \(progress)")
        
        var width = (self.frame.width - margin) * progress
        var height = (self.frame.height - margin)
        
        print(width)
        
        if width < height {
            width = height
        }
        
        let path = UIBezierPath(roundedRect: CGRect(x: margin/2, y: margin/2, width: width, height: height), cornerRadius: height/2)
        
        color.setFill()
        path.fill()
        
        UIColor.clear.setStroke()
        path.stroke()
        
        path.close()
    }
    
}
