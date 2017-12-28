//
//  ScratchViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/26.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import PocketSVG
import AudioToolbox

class ScratchViewController: UIViewController {

    @IBOutlet weak var mask: UIView!
    @IBOutlet weak var wantToShowView: UIView!
    var scratchableUIVIew = UIView()
    var baseView = UIView()
    
    var scratchCardView: ScratchCardView?
    
    var countryPath = UIBezierPath()
    var pictureSize = CGSize.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIView(path: countryPath, continentColor: UIColor.blue, parentView: baseView)
        setupUIView(path: countryPath, continentColor: UIColor.gray, parentView: scratchableUIVIew)
        
//            let layer1 = CAShapeLayer()
////            calculatePictureBounds(rect: countryPath.cgPath.boundingBox)
//            layer1.path = countryPath.cgPath
//            layer1.fillColor = UIColor.blue.cgColor
//
//            let strokeWidth1 = CGFloat(0.5)
//            let strokeColor1 = UIColor.white.cgColor
//
//            layer1.lineWidth = strokeWidth1
//            layer1.strokeColor = strokeColor1
//            layer1.shadowColor = UIColor.gray.cgColor
//            layer1.shadowOpacity = 0.5
//            layer1.shadowOffset = CGSize(width: 0.0, height: 20.0)
//
//            self.baseView.layer.addSublayer(layer1)
////            self.view.addSubview(baseView)
//
//            let layer = CAShapeLayer()
//            layer.path = countryPath.cgPath
//            layer.fillColor = UIColor.gray.cgColor
//
//            let strokeWidth = CGFloat(0.5)
//            let strokeColor = UIColor.white.cgColor
//
//            layer.lineWidth = strokeWidth
//            layer.strokeColor = strokeColor
//
//            layer.lineWidth = strokeWidth1
//            layer.strokeColor = strokeColor1
//            layer.shadowColor = UIColor.gray.cgColor
//            layer.shadowOpacity = 0.5
//            layer.shadowOffset = CGSize(width: 0.0, height: 20.0)
//
//            self.scratchableUIVIew.layer.addSublayer(layer)
            self.wantToShowView.addSubview(baseView)
            self.mask.addSubview(scratchableUIVIew)
        
        // can't scratch
//            self.view.addSubview(baseView)
//            self.view.addSubview(scratchableUIVIew)
        
         setupView()
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
//        setupView()

//        let maskImage = UIImage.init(view: scratchableUIVIew)
//
//        let scratchView = ScratchView(frame: UIScreen.main.bounds, countryView: baseView, maskImage: maskImage)
//        //
//        scratchView.delegate = self
//        self.view.addSubview(scratchView)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func setupView() {
        
        //        let imageView = UIImageView(image: #imageLiteral(resourceName: "base.jpg"))
        //        imageView.contentMode = .scaleAspectFill
        //
        //        let coverView = UIImageView(image: #imageLiteral(resourceName: "cover.jpg"))
        //        coverView.contentMode = .scaleAspectFill
        
        let screen = UIScreen.main.bounds
        scratchCardView = ScratchCardView(frame: screen)
        scratchCardView!.setupWith(coverView: mask, contentView: wantToShowView)
        view.addSubview(scratchCardView!)
        
    }
    
    func setupUIView(path: UIBezierPath, continentColor: UIColor, parentView: UIView) {
        
        let layer = CAShapeLayer()
        //            calculatePictureBounds(rect: countryPath.cgPath.boundingBox)
        layer.path = path.cgPath
        layer.fillColor = continentColor.cgColor
        
        let strokeWidth = CGFloat(0.5)
        let strokeColor = UIColor.white.cgColor
        
        layer.lineWidth = strokeWidth
        layer.strokeColor = strokeColor
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 20.0)
        
        parentView.layer.addSublayer(layer)
        
    }
    
//    func calculatePictureBounds(rect: CGRect) {
//
//        let maxX = rect.minX + rect.width
//        let maxY = rect.minY + rect.height
//
//        self.pictureSize.width = self.pictureSize.width > maxX ? self.pictureSize.width: maxX
//        self.pictureSize.height = self.pictureSize.height > maxY ? self.pictureSize.height : maxY
//    }

    
//    func calculateScaleFactor() -> CGFloat {
//
//        let boundingBoxAspectRatio = baseView.bounds.width/baseView.bounds.height
//        let viewAspectRatio = self.view.bounds.width/(self.view.bounds.height)
//
//        let scaleFactor: CGFloat
//        if (boundingBoxAspectRatio > viewAspectRatio) {
//            // Width is limiting factor
//            scaleFactor = self.view.bounds.width/scrollView.contentSize.width
//        } else {
//            // Height is limiting factor
//            scaleFactor = (self.view.bounds.height - 110)/scrollView.contentSize.height
//        }
    
//        return scaleFactor
    
        //        let scaleFactor = transformRatio()
        //
        //        var affineTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        //
        //        let transformedPath = (path.cgPath).copy(using: &affineTransform)
        //
        //        let layer = CAShapeLayer()
        //        layer.path = transformedPath
        
//    }
    
//    func scratchBegan(point: CGPoint) {
//        print("开始刮奖：\(point)")
//    }
//
//    func scratchMoved(progress: Float) {
//
//        print("当前进度：\(progress)")
//
////        let percent = String(format: "%.1f", progress * 100)
////        label.text = "Scratch: \(percent)%"
//
//    }
//
//    func scratchEnded(point: CGPoint) {
//        print("停止刮奖：\(point)")
//    }
}
