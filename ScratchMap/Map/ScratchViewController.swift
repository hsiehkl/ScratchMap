//
//  ScratchViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/26.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import PocketSVG

class ScratchViewController: UIViewController, ScratchViewDelegate {

    @IBOutlet weak var baseView: UIView!
//    @IBOutlet weak var scratchableUIVIew: UIView!
    var scratchableUIVIew = UIView()
    
    var countryPath = UIBezierPath()
    var pictureSize = CGSize.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            self.view.backgroundColor = UIColor.clear
            baseView.backgroundColor = UIColor.clear
            scratchableUIVIew.backgroundColor = UIColor.clear
        
        
            let layer1 = CAShapeLayer()
            calculatePictureBounds(rect: countryPath.cgPath.boundingBox)
            layer1.path = countryPath.cgPath
            layer1.fillColor = UIColor.blue.cgColor
        
            let strokeWidth1 = CGFloat(0.5)
            let strokeColor1 = UIColor.white.cgColor
        
            layer1.lineWidth = strokeWidth1
            layer1.strokeColor = strokeColor1
        
            self.baseView.layer.addSublayer(layer1)
        
            let layer = CAShapeLayer()
            layer.path = countryPath.cgPath
            layer.fillColor = UIColor.gray.cgColor
            
            let strokeWidth = CGFloat(0.5)
            let strokeColor = UIColor.white.cgColor
            
            layer.lineWidth = strokeWidth
            layer.strokeColor = strokeColor
        
            self.baseView.addSubview(<#T##view: UIView##UIView#>)
            self.scratchableUIVIew.layer.addSublayer(layer)
        

        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let maskImage = UIImage.init(view: scratchableUIVIew)
        
        let scratchView = ScratchView(frame: UIScreen.main.bounds, countryView: baseView, maskImage: maskImage)
        //
        scratchView.delegate = self
        self.view.addSubview(scratchView)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculatePictureBounds(rect: CGRect) {
        
        let maxX = rect.minX + rect.width
        let maxY = rect.minY + rect.height
        
        self.pictureSize.width = self.pictureSize.width > maxX ? self.pictureSize.width: maxX
        self.pictureSize.height = self.pictureSize.height > maxY ? self.pictureSize.height : maxY
    }

    
    func calculateScaleFactor() -> CGFloat {
        
        let boundingBoxAspectRatio = baseView.bounds.width/baseView.bounds.height
        let viewAspectRatio = self.view.bounds.width/(self.view.bounds.height)
        
        let scaleFactor: CGFloat
        if (boundingBoxAspectRatio > viewAspectRatio) {
            // Width is limiting factor
            scaleFactor = self.view.bounds.width/scrollView.contentSize.width
        } else {
            // Height is limiting factor
            scaleFactor = (self.view.bounds.height - 110)/scrollView.contentSize.height
        }
        
        return scaleFactor
        
        //        let scaleFactor = transformRatio()
        //
        //        var affineTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        //
        //        let transformedPath = (path.cgPath).copy(using: &affineTransform)
        //
        //        let layer = CAShapeLayer()
        //        layer.path = transformedPath
        
    }
    
    func scratchBegan(point: CGPoint) {
        print("开始刮奖：\(point)")
    }
    
    func scratchMoved(progress: Float) {
        
        print("当前进度：\(progress)")
        
//        let percent = String(format: "%.1f", progress * 100)
//        label.text = "Scratch: \(percent)%"
        
    }
    
    func scratchEnded(point: CGPoint) {
        print("停止刮奖：\(point)")
    }
}
