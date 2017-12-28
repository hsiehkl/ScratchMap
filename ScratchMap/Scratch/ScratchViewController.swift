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
    var coverView = UIView()
    var baseView = UIView()
    
    var scratchCardView: ScratchCardView?
    
    var countryPath = UIBezierPath()
    var pictureSize = CGSize.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCountryLayerOnUIView(path: countryPath, continentColor: UIColor.blue, parentView: baseView)
        setupCountryLayerOnUIView(path: countryPath, continentColor: UIColor.gray, parentView: coverView)
        
        self.wantToShowView.addSubview(baseView)
        self.mask.addSubview(coverView)
        
        // can't scratch
//            self.view.addSubview(baseView)
//            self.view.addSubview(scratchableUIVIew)
        
        setupScratchableView()
        tapRecognizerSetup()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func setupScratchableView() {
        
        let screen = UIScreen.main.bounds
        scratchCardView = ScratchCardView(frame: screen)
        scratchCardView!.setupWith(coverView: mask, contentView: wantToShowView)
        view.addSubview(scratchCardView!)
        
    }
    
    func setupCountryLayerOnUIView(path: UIBezierPath, continentColor: UIColor, parentView: UIView) {
        
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
    
    func tapRecognizerSetup() {
        
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.vibrate(tapRecognizer:))
        )
        
        self.wantToShowView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc public func vibrate(tapRecognizer: UITapGestureRecognizer) {
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        print("vibrate!!")
        
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
