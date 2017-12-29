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
//    var pictureSize = CGSize.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scaleTransformedPath = transformPathScale(path: countryPath)
        let translateTransformedPath = transformPathTranslation(scaleTransformedPath: scaleTransformedPath)
        
        setupCountryLayerOnUIView(path: translateTransformedPath, continentColor: UIColor.blue, parentView: baseView)
        setupCountryLayerOnUIView(path: translateTransformedPath, continentColor: UIColor.gray, parentView: coverView)
        
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
    
    func setupCountryLayerOnUIView(path: CGPath, continentColor: UIColor, parentView: UIView) {
        
        let layer = CAShapeLayer()

        layer.path = path
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

    func transformPathScale(path: UIBezierPath)-> CGPath {
        
        let pathBoundingBox = path.cgPath.boundingBox
        
        let boundingBoxAspectRatio = pathBoundingBox.width/pathBoundingBox.height
        
        let viewAspectRatio = mask.frame.width/mask.frame.height

        var scaleFactor: CGFloat = 1.0
        
        if (boundingBoxAspectRatio > viewAspectRatio) {
            // Width is limiting factor
            scaleFactor = mask.frame.width/pathBoundingBox.width
        } else {
            // Height is limiting factor
            scaleFactor = mask.frame.height/pathBoundingBox.height
        }
        
        var scaleTransform = CGAffineTransform.identity
        
        scaleTransform = scaleTransform.scaledBy(x: scaleFactor, y: scaleFactor)
        //        scaleTransform.translatedBy(x: -pathBounding.minX, y: -pathBounding.minY)
        
        print("縮放\(scaleTransform)")
        
//        let scaleRate = pathBoundingBox.size.applying(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        
//        print("scaleSize: \(scaleRate)")

        print("平移\(scaleTransform)")
        
        guard let scaleTransformedPath = (path.cgPath).copy(using: &scaleTransform) else { return path.cgPath }
        
        return scaleTransformedPath
    }
    
    func transformPathTranslation(scaleTransformedPath: CGPath)-> CGPath {
        
        let scaledPathBoundingBox = scaleTransformedPath.boundingBox
     
        let maskCenterX = (mask.frame.maxX + mask.frame.minX)/2
        let maskCenterY = (mask.frame.minY + mask.frame.maxY)/2
        
        let centerOffset = CGSize(width: -(scaledPathBoundingBox.midX-maskCenterX), height: -(scaledPathBoundingBox.midY-maskCenterY))
        
        var translateTransform = CGAffineTransform.identity
        translateTransform = translateTransform.translatedBy(x: centerOffset.width, y: centerOffset.height)
        
        print("translattrnasform: \(translateTransform)")
        guard let translateTransformedPath = (scaleTransformedPath).copy(using: &translateTransform) else { return scaleTransformedPath }
        
        return translateTransformedPath
        
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
//
//    func calculatePictureBounds(rect: CGRect) {
//
////        var pictureSize = CGRect.
//
//        let maxX = rect.minX + rect.width
//        let maxY = rect.minY + rect.height
//
//        print("min!!~~\(rect.minX)")
////        let minX = rect.minX +
//
//        self.pictureSize.width = self.pictureSize.width > maxX ? self.pictureSize.width: maxX
//        self.pictureSize.height = self.pictureSize.height > maxY ? self.pictureSize.height : maxY
//    }
//
//
//    func calculateScaleFactor(rect: CGRect, parentView: UIView) -> CGFloat {
//
//        let boundingBoxAspectRatio = rect.width/rect.height
//        let viewAspectRatio = parentView.bounds.width/(parentView.bounds.height)
//
//        let scaleFactor: CGFloat
//        if (boundingBoxAspectRatio > viewAspectRatio) {
//            // Width is limiting factor
//            scaleFactor = parentView.bounds.width/rect.width
//        } else {
//            // Height is limiting factor
//            scaleFactor = (parentView.bounds.height)/rect.height
//        }
//
//        return scaleFactor
//
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
    //
    //        let pathBounding = countryPath.cgPath.boundingBox
    ////        calculatePictureBounds(rect: pathBounding)
    //        print("oldbox: \(pathBounding)")
    //
    ////        print("pathBounding寬高: \(pathBounding.width), \(pathBounding.height)")
    //
    //        let boundingBoxAspectRatio = pathBounding.width/pathBounding.height
    //        print("ratio: \(boundingBoxAspectRatio)")
    //
    //        let viewAspectRatio = mask.frame.width/mask.frame.height
    //
    //        print("viewAspectRatio: \(viewAspectRatio)")
    //
    //        var scaleFactor: CGFloat = 1.0
    //        if (boundingBoxAspectRatio > viewAspectRatio) {
    //            // Width is limiting factor
    //            scaleFactor = mask.frame.width/pathBounding.width
    //        } else {
    //            // Height is limiting factor
    //            scaleFactor = mask.frame.height/pathBounding.height
    //        }
    //
    //        print("scaleFactor: \(scaleFactor)")
    //
    //        var scaleTransform = CGAffineTransform.identity
    //        scaleTransform = scaleTransform.scaledBy(x: scaleFactor, y: scaleFactor)
    ////        scaleTransform.translatedBy(x: -pathBounding.minX, y: -pathBounding.minY)
    //
    //        print("縮放\(scaleTransform)")
    //
    //        let scaleSize = pathBounding.size.applying(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
    //
    //        print("scaleSize: \(scaleSize)")
    //
    //        print("pathboundingScaled: \(pathBounding.minX)")
    //
    ////        let centerOffset = CGSize(width: ((mask.frame.width-scaleSize.width)/(scaleFactor*2.0)), height:((mask.frame.height-scaleSize.height)/(scaleFactor*2.0)))
    //
    ////        let newBoundingBoxCenterX = (pathBounding.minX*scaleFactor + pathBounding.maxX*scaleFactor)/2
    ////        let newBoundingBoxCenterY = (pathBounding.minY*scaleFactor + pathBounding.maxY*scaleFactor)/2
    ////        let boundingBoxCenterX = (pathBounding.minX + pathBounding.maxX)/2
    ////        let boundingBoxCenterY = (pathBounding.minY + pathBounding.maxY)/2
    ////        let maskCenterX = (mask.frame.maxX + mask.frame.minX)/2
    ////        let maskCenterY = (mask.frame.minY + mask.frame.maxY)/2
    //
    ////        print("CenterX: \(newBoundingBoxCenterX), \(maskCenterX)")
    ////        print("CenterY: \(newBoundingBoxCenterY), \(maskCenterY)")
    ////        let centerOffset = CGSize(width: -(newBoundingBoxCenterX-maskCenterX), height: -(newBoundingBoxCenterY-maskCenterY))
    ////
    ////        print("centeroffset: \(centerOffset)")
    //
    ////        scaleTransform = scaleTransform.translatedBy(x: centerOffset.width, y: centerOffset.height)
    //
    //        print("平移\(scaleTransform)")
    //
    //        guard let scaledAndTransformedPath = (countryPath.cgPath).copy(using: &scaleTransform) else { return }
    //
    //        print("newbox: \(scaledAndTransformedPath.boundingBox)")
    //
    //        let box = scaledAndTransformedPath.boundingBox
    //        print("\(box.midY), \(box.minY) \(box.maxY), \(box.midX), \(box.minX), \(box.maxX)")
    //
    ////        let newBoundingBoxCenterX = (scaledAndTransformedPath.boundingBox.minY + (scaledAndTransformedPath.boundingBox.minY+scaledAndTransformedPath.boundingBox.width))/2
    ////        let newBoundingBoxCenterY = (scaledAndTransformedPath.boundingBox.minY + (scaledAndTransformedPath.boundingBox.minY+scaledAndTransformedPath.boundingBox.height))/2
    //        let maskCenterX = (mask.frame.maxX + mask.frame.minX)/2
    //        let maskCenterY = (mask.frame.minY + mask.frame.maxY)/2
    //
    ////        print("newBoundingBoxCenter: \(newBoundingBoxCenterX), \(newBoundingBoxCenterY)")
    //        print("maskCenter: \(maskCenterX), \(maskCenterY)")
    //
    //        let centerOffset = CGSize(width: -(box.midX-maskCenterX), height: -(box.midY-maskCenterY))
    //
    //        var translateTransform = CGAffineTransform.identity
    //        translateTransform = translateTransform.translatedBy(x: centerOffset.width, y: centerOffset.height)
    //
    //        print("translattrnasform: \(translateTransform)")
    //        guard let translateTransformedPath = (scaledAndTransformedPath).copy(using: &translateTransform) else { return }
    //
    //        print("translate:::: \(translateTransformedPath.boundingBox)")
}
