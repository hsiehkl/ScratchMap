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
    @IBOutlet weak var label: UILabel!
    
    var countryUIView = UIView()
//    var maskView = UIView()
    
    func scratchBegan(point: CGPoint) {
        print("开始刮奖：\(point)")
    }
    
    func scratchMoved(progress: Float) {
        print("当前进度：\(progress)")

        let percent = String(format: "%.1f", progress * 100)
        label.text = "Scratch: \(percent)%"

    }
    
    func scratchEnded(point: CGPoint) {
        print("停止刮奖：\(point)")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(countryUIView)
//        self.view.addSubview(maskView)
        
        let url = Bundle.main.url(forResource: "worldHigh", withExtension: "svg")!
        
//        let urltw = Bundle.main.url(forResource: "tw", withExtension: "svg")!
        
//        let pathstw = SVGBezierPath.pathsFromSVG(at: urltw)
        
//        for path in pathstw {
//
//            let layer = CAShapeLayer()
//            layer.path = path.cgPath
//            layer.fillColor = UIColor.gray.cgColor
//
//            let strokeWidth = CGFloat(0.5)
//            let strokeColor = UIColor.white.cgColor
//
//            layer.lineWidth = strokeWidth
//            layer.strokeColor = strokeColor
//
//            self.maskView.layer.addSublayer(layer)
//        }
        
        let paths = SVGBezierPath.pathsFromSVG(at: url)
        
        for path in paths {
            
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.fillColor = UIColor.gray.cgColor
            
            let strokeWidth = CGFloat(0.5)
            let strokeColor = UIColor.white.cgColor
            
            layer.lineWidth = strokeWidth
            layer.strokeColor = strokeColor
            
            self.countryUIView.layer.addSublayer(layer)
        }
        
        let scratchView = ScratchView(frame: UIScreen.main.bounds, countryView: countryUIView, maskImage: UIImage(named:"tw.png")!)
        
//        let scratchView = ScratchView(frame: UIScreen.main.bounds, countryView: countryUIView, maskImage: maskView)
        
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
