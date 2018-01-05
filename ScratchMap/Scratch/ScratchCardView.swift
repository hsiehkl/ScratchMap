//
//  ScratchCardView.swift
//  UIViewMaskPratice
//
//  Created by Cheng-Shan Hsieh on 2017/12/28.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit

class ScratchCardView: UIView {
    
    private var coverView = UIView()
    private var contentView =  UIView()
    private var contentMaskView = ScratchCardMaskView()
    
    var strokeWidth: CGFloat = 0 {
        
        didSet {
            self.contentMaskView.strokeWidth = self.strokeWidth
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWith(coverView: UIView, contentView: UIView) {
        
        // cover view
        self.coverView = coverView
        
        // content view
        self.contentView = contentView
        
        // mask view
        self.contentMaskView.frame = coverView.frame
        self.contentMaskView.backgroundColor = UIColor.clear
        self.contentMaskView.strokeWidth = 40.0
        
        // addsubviews
        addSubViewFullScreen(self.coverView)
        addSubViewFullScreen(self.contentView)
        addSubViewFullScreen(self.contentMaskView)
        
        // set mask
        self.contentView.mask = self.contentMaskView
        
        print("coverView: \(coverView.frame)")
        print("contentView: \(contentView.frame)")
        
        // add gesture
        setupGesture()
        
    }
    
    private func addSubViewFullScreen(_ subView: UIView) {
        
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(subView)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[subView]-(0)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["subView": subView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[subView]-(0)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["subView": subView]))
        
    }
    
    private func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: contentMaskView, action: #selector(contentMaskView.panGestureRecongnizer(_:)))
        
        self.addGestureRecognizer(panGesture)
    }
    
    public func clearCanvas() {
        contentMaskView.clearCanvas()
    }
    
    
}
