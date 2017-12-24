//
//  ScratchView.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/21.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit

protocol ScratchViewDelegate: class {
    
    func scratchBegan(point: CGPoint)
    func scratchMoved(progress: Float)
    func scratchEnded(point: CGPoint)
}

class ScratchView: UIView {
    
    var scratchMask: ScratchMask!
    
//    var countryImageView: UIImageView!
    var countryUIView: UIView!
    
    weak var delegate: ScratchViewDelegate? {
        
        didSet {
            
            scratchMask.delegate = delegate
            
        }
    }
    
//    public init(frame: CGRect, countryImage: UIImage, maskImage: UIImage, scratchWidth: CGFloat = 15, scrachType: CGLineCap = .square) {
    
    public init(frame: CGRect, countryView: UIView, maskImage: UIImage, scratchWidth: CGFloat = 15, scrachType: CGLineCap = .square) {
    
        super.init(frame: frame)
        
        let childFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
//        countryImageView = UIImageView(frame: childFrame)
        countryUIView = UIView(frame: childFrame)
//        countryImageView.image = countryImage
//        self.addSubview(countryImageView)
        self.addSubview(countryUIView)
        
        scratchMask = ScratchMask(frame: childFrame)
        scratchMask.image = maskImage
        scratchMask.linetype = scrachType
        scratchMask.lineWidth = scratchWidth
        self.addSubview(scratchMask)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
