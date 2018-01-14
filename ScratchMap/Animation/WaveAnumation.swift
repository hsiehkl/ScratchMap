//
//  WaveAnumation.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/11.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//
import UIKit

class WaveView: UIView {
    
    var waveCurvature: CGFloat = 1.5
    
    var waveSpeed: CGFloat = 0.6
    
    var waveHeight: CGFloat = 8
    
    var realWaveColor: UIColor = UIColor.red {
        
        didSet {
            self.realWaveLayer.fillColor = self.realWaveColor.cgColor
        }
        
    }
    
    var maskWaveColor: UIColor = UIColor.red {
        
        didSet {
            self.maskWaveLayer.fillColor = self.maskWaveColor.cgColor
        }
    }
    
    var overView: UIView?
    
    var timer: CADisplayLink?
    
    var realWaveLayer: CAShapeLayer = CAShapeLayer()
    
    var maskWaveLayer: CAShapeLayer = CAShapeLayer()
    
    var offset: CGFloat = 0
    
    var _waveCurvature: CGFloat = 0
    
    var _waveSpeed: CGFloat = 0
    
    var _waveHeight: CGFloat = 0
    
    var _strating: Bool = false
    
    var _stoping: Bool = false
    
    /**
     Init view
     
     - parameter frame: view frame
     
     - returns: view
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var frame = self.bounds
        
        frame.origin.y = frame.size.height
        frame.size.height = 0
        maskWaveLayer.frame = frame
        realWaveLayer.frame = frame
        self.backgroundColor = UIColor.clear
        
    }
    
    /**
     Init view with wave color
     
     - parameter frame: view frame
     - parameter color: real wave color
     
     - returns: view
     */
    
    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        
        self.realWaveColor = color
        self.maskWaveColor = color.withAlphaComponent(0.4)
        
        realWaveLayer.fillColor = self.realWaveColor.cgColor
        maskWaveLayer.fillColor = self.maskWaveColor.cgColor
        
        self.layer.addSublayer(self.realWaveLayer)
        self.layer.addSublayer(maskWaveLayer)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Add over view
     
     - parameter view: overview
     */
    
    func addOverView(_ view: UIView) {
        
        overView = view
        
        overView?.center = self.center
        
        overView?.frame.origin.y = self.frame.height - (overView?.frame.height)!
        
        self.addSubview(overView!)
        
    }
    
    func start() {
        
        if !_strating {
            _stop()
            _strating = true
            _stoping = false
            _waveHeight = 0
            _waveSpeed = 0
            _waveCurvature = 0
            
            timer = CADisplayLink(target: self, selector: #selector(wave))
            timer?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        }
        
    }
    
    /**
     Stop wave
     */
    
    func _stop() {
        
        if (time != nil) {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func stop() {
        
        if !_stoping {
            _strating = false
            _stoping = true
            
        }
    }
    
    /**
     Wave animation
     */
    
    @objc func wave() {
        
        if _strating {
            
            if _waveHeight < waveHeight {
                _waveHeight = _waveHeight + waveHeight/100.0
                var frame = self.bounds
                frame.origin.y = frame.size.height - _waveHeight
                frame.size.height = _waveHeight
                maskWaveLayer.frame = frame
                realWaveLayer.frame = frame
                _waveCurvature = _waveCurvature + waveCurvature/100.0
                _waveSpeed = _waveSpeed + waveSpeed/100.0
                
            } else {
                _strating = false
            }
        }
        
        if _stoping {
            
            if _waveHeight > 0 {
                
                _waveHeight = _waveHeight - waveHeight/50.0
                var frame = self.bounds
                frame.origin.y = frame.size.height
                frame.size.height = _waveHeight
                maskWaveLayer.frame = frame
                realWaveLayer.frame = frame
                _waveCurvature = _waveCurvature - _waveCurvature/50.0
                _waveSpeed = _waveSpeed - waveSpeed/50.0
                
            } else {
                
                _stoping = false
                _stop()
            }
            
        }
        
        
        offset += _waveSpeed
        
        let width = frame.width
        let height = CGFloat(_waveHeight)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: height))
        var y: CGFloat = 0
        
        let maskPath = CGMutablePath()
        maskPath.move(to: CGPoint(x: 0, y: height))
        
        let offset_f = Float(offset * 0.045)
        let waveCurvature_f = Float(0.01 * _waveCurvature)
        
        for x in 0...Int(width) {
            
            y = height * CGFloat(sinf(waveCurvature_f * Float(x) + offset_f))
            
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
            maskPath.addLine(to: CGPoint(x: CGFloat(x), y: -y))
        }
        
        if (overView != nil) {
            
            let centX = self.bounds.size.width/2
            let centY = height * CGFloat(sinf(waveCurvature_f * Float(centX) + offset_f))
            let center = CGPoint(x: centX, y: centY + self.bounds.size.height - overView!.bounds.size.height/2 - _waveHeight - 1)
            overView?.center = center
            
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        
        path.closeSubpath()
        self.realWaveLayer.path = path
        
        maskPath.addLine(to: CGPoint(x: width, y: height))
        maskPath.addLine(to: CGPoint(x: 0, y: height))
        
        maskPath.closeSubpath()
        self.maskWaveLayer.path = maskPath
        
    }
    
//    func loadingAnimation() {
//        
//        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//        backgroundView.backgroundColor = UIColor(red: 127.0 / 255.0, green: 190.0 / 255.0, blue: 21.0 / 255.0, alpha: 1)
//        
//        let frame = CGRect(x: 0, y: -100, width: self.view.bounds.width, height: 100)
//        waterView = WaveView(frame: frame, color: UIColor(red: 132.0 / 255.0, green: 191.0 / 255.0, blue: 230.0 / 255.0, alpha: 1))
//        //        waterView!.addOverView(avatarView)
//        waterView?.backgroundColor = UIColor.clear
//        
//        self.view.addSubview(backgroundView)
//        //        backgroundView.addSubview(waterView!)
//        self.view.addSubview(waterView!)
//        
//        waterView!.start()
//        
//        //        UIView.animate(withDuration: 5) {
//        ////            self.waterView!.center.y += self.view.bounds.height
//        //            backgroundView.center.y += self.view.bounds.height
//        //            self.view.backgroundColor = UIColor.white
//        //
//        //        }
//        
//        UIView.animate(withDuration: 3, animations: {
//            self.waterView!.center.y += (self.view.bounds.height)
//            backgroundView.center.y += (self.view.bounds.height)
//        }) { (true) in
//            //            backgroundView.removeFromSuperview()
//        }
//    }

    
}
