//
//  ViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/15.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import PocketSVG

class ViewController: UIViewController {
    
    var paths = [SVGBezierPath]()

    override func viewDidLoad() {
        super.viewDidLoad()
         svgWorldMapSetup()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func svgWorldMapSetup() {
        
        let url = Bundle.main.url(forResource: "worldHigh", withExtension: "svg")!
        let paths = SVGBezierPath.pathsFromSVG(at: url)
        self.paths = paths
        
        for path in paths {
            // Create a layer for each path
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.fillColor = UIColor.gray.cgColor
            
            // Default Settings
            let strokeWidth = CGFloat(1.0)
            let strokeColor = UIColor.white.cgColor
            
            layer.lineWidth = strokeWidth
            layer.strokeColor = strokeColor
            
            self.view.layer.addSublayer(layer)
        }
    }

}
