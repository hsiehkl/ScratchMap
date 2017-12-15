//
//  ViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/15.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import PocketSVG

class MainPageController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let mapContainerView = UIView()
//    private var imageView = UIImage()
    var paths = [SVGBezierPath]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollViewSetUp()
        svgWorldMapSetup()
        tapRecognizerSetup()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
            
            self.mapContainerView.layer.addSublayer(layer)
        }
    }
    
//    func svgImageViewSetup() {
//
//        let url = Bundle.main.url(forResource: "worldHigh", withExtension: "svg")!
//
//        let svgImageView = SVGImageView.init(contentsOf: url)
//
//        svgImageView.frame = mapContainerView.bounds
//
//        self.mapContainerView.addSubview(svgImageView)
//    }
    
    func scrollViewSetUp() {
        
        scrollView.frame = self.view.bounds
        
        scrollView.contentSize = CGSize(width: 1100, height: 800)
        
        let scrollViewFrame = scrollView.frame
        
        mapContainerView.frame = CGRect(
            x: scrollViewFrame.minX + 20,
            y: scrollViewFrame.minY,
            width: scrollViewFrame.width,
            height: scrollViewFrame.height
        )
        
        scrollView.bounces = false
        
        self.scrollView.addSubview(self.mapContainerView)
        
        self.view.addSubview(self.scrollView)
        
    }
    
    func tapRecognizerSetup() {
        
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.tapLocationDetected(tapRecognizer:))
        )
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    
    @objc public func tapLocationDetected(tapRecognizer: UITapGestureRecognizer) {
        
        let tapLocation: CGPoint = tapRecognizer.location(in: self.mapContainerView)
        
        self.colorSelectedCountry(tapLocation: CGPoint(x: tapLocation.x, y: tapLocation.y))
        
    }

    private func colorSelectedCountry(tapLocation: CGPoint) {
        
        for path in paths {
            
            if path.contains(tapLocation) {
                
                let layer = CAShapeLayer()
                layer.path = path.cgPath
                layer.fillColor = UIColor.red.cgColor
                
                let strokeWidth = CGFloat(1.0)
                let strokeColor = UIColor.blue.cgColor
                
                layer.lineWidth = strokeWidth
                layer.strokeColor = strokeColor
                self.mapContainerView.layer.addSublayer(layer)
                
            } else {
                
                print("Not a country")
            }
        }
    }
    
}
