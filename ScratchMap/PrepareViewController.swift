//
//  PrepareViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/19.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import Firebase
import PocketSVG

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
        

//        self.view.backgroundColor = UIColor(gradientStyle: .leftToRight, withFrame: self.view.bounds, andColors:[
//            UIColor(red: 91.0 / 255.0, green: 211.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0),
////            UIColor(red: 69.0 / 255.0, green: 230.0 / 255.0, blue: 136.0 / 255.0, alpha: 1.0),
//             UIColor(red: 233.0 / 255.0, green: 251.0 / 255.0, blue: 163.0 / 255.0, alpha: 1.0)
//            ])
        
        let scratchView = ScratchView(frame: CGRect(x:50, y:150, width:241, height:280), countryImage: #imageLiteral(resourceName: "tw.png"), maskImage: #imageLiteral(resourceName: "gray.jpg"))
        
        scratchView.delegate = self
        self.view.addSubview(scratchView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
