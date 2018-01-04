//
//  ScratchCardMaskView.swift
//  UIViewMaskPratice
//
//  Created by Cheng-Shan Hsieh on 2017/12/28.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import AudioToolbox

class ScratchCardMaskView: UIView {
    
    var strokeWidth: CGFloat = 10
    var strokeColor = UIColor.black
    
    fileprivate var paths: [CGMutablePath] = []
    fileprivate var currentPath: CGMutablePath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(strokeColor.cgColor)
        context?.setLineWidth(strokeWidth)
        context?.setLineCap(.square)
        
        for path in paths + [currentPath].flatMap({$0}) {
            context?.addPath(path)
            context?.strokePath()
        }
    }
    
    @objc func panGestureRecongnizer(_ recognizer: UIPanGestureRecognizer) {
        
        let location = recognizer.location(in: self)

        switch recognizer.state {
        case .began:
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            print("!!!!!!!!!boom!!!!!!!!")
            begainPath(at: location)
            
        case .changed:
//            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            addLine(to: location)
            
        default:
            closePath()

        }
    }
    
    public func clearCanvas() {
        paths.removeAll()
        setNeedsDisplay()
    }
    
    public func begainPath(at point: CGPoint) {
        
        currentPath = CGMutablePath()
        currentPath?.move(to: point)
        setNeedsDisplay()
        
    }
    
    public func addLine(to point: CGPoint) {
        currentPath?.addLine(to: point)
        setNeedsDisplay()
    }
    
    public func closePath() {
        if let currentPath = currentPath {
            paths.append(currentPath)
        }
        
        currentPath = nil
        setNeedsDisplay()
    }
}
