//
//  PrepareViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/19.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import Firebase

class PrepareViewController: UIViewController, ScratchViewDelegate {
    func scratchBegan(point: CGPoint) {
        print("开始刮奖：\(point)")
    }
    
    func scratchMoved(progress: Float) {
        print("当前进度：\(progress)")
    }
    
    func scratchEnded(point: CGPoint) {
        print("停止刮奖：\(point)")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(gradientStyle: .leftToRight, withFrame: self.view.bounds, andColors:[
            UIColor(red: 3.0 / 255.0, green: 63.0 / 255.0, blue: 122.0 / 255.0, alpha: 1.0),
            UIColor(red: 4.0 / 255.0, green: 107.0 / 255.0, blue: 149.0 / 255.0, alpha: 1.0)
            ])
        
//        let scratchView = ScratchView(frame: CGRect(x:20, y:80, width:241, height:106), countryImage: #imageLiteral(resourceName: "Europe"), maskImage: #imageLiteral(resourceName: "Asia"))
        
//        scratchView.delegate = self
//        self.view.addSubview(scratchView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
