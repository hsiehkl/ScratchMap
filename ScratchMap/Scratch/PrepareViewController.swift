//
//  PrepareViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/19.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import Firebase
import PocketSVG

class PrepareViewController: UIViewController, UIScrollViewDelegate, ScratchViewDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var countryView: ScratchView!
    
    var pictureSize = CGSize.zero
    
    private let scrollView = UIScrollView()
//    var countryUIView = UIView()
    var maskView = UIView()
    var countryPath = SVGBezierPath()
    
    func scratchBegan(point: CGPoint) {
        print("开始刮奖：\(point)")
    }
    
    func scratchMoved(progress: Float) {
        
//        print("当前进度：")
        print("当前进度：\(progress)")

        let percent = String(format: "%.1f", progress * 100)
        label.text = "Scratch: \(percent)%"

    }
    
    func scratchEnded(point: CGPoint) {
        print("停止刮奖：\(point)")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.addSubview(countryUIView)
        self.view.addSubview(maskView)
//
        let url = Bundle.main.url(forResource: "tw", withExtension: "svg")!
//
        let urltw = Bundle.main.url(forResource: "tw", withExtension: "svg")!

        let pathstw = SVGBezierPath.pathsFromSVG(at: urltw)

        for path in pathstw {

            self.calculatePictureBounds(rect: path.cgPath.boundingBox)
            
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.fillColor = UIColor.blue.cgColor

            let strokeWidth = CGFloat(0.5)
            let strokeColor = UIColor.white.cgColor

            layer.lineWidth = strokeWidth
            layer.strokeColor = strokeColor

            self.maskView.layer.addSublayer(layer)
        }
        
        let paths = SVGBezierPath.pathsFromSVG(at: url)
        
        for path in paths {
            
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.fillColor = UIColor.gray.cgColor
            
            let strokeWidth = CGFloat(0.5)
            let strokeColor = UIColor.white.cgColor
            
            layer.lineWidth = strokeWidth
            layer.strokeColor = strokeColor
            
            self.countryView.layer.addSublayer(layer)
        }
        
//        scrollViewSetUp()
 
        maskView.frame = CGRect(x: 30, y: 50, width: pictureSize.width, height: pictureSize.height)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let maskImage = UIImage.init(view: maskView)
        
        let scratchView = ScratchView(frame: UIScreen.main.bounds, countryView: countryView, maskImage: maskImage)
//
        scratchView.delegate = self
        self.view.addSubview(scratchView)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func svgCountrySetup() {
//
//        self.calculatePictureBounds(rect: countryPath.cgPath.boundingBox)
//
//        let layer = CAShapeLayer()
//        layer.path = countryPath.cgPath
//        layer.fillColor = UIColor.gray.cgColor
//        //
//        let strokeWidth = CGFloat(0.5)
//        let strokeColor = UIColor.white.cgColor
//
//        layer.lineWidth = strokeWidth
//        layer.strokeColor = strokeColor
//
//        self.countryUIView.layer.addSublayer(layer)
//        }
    
//    func scrollViewSetUp() {
//
//        //setupMapContainerView
//
//        countryUIView.contentMode = .center
//        countryUIView.isUserInteractionEnabled = true
//
//        countryUIView.frame = CGRect(
//            x: scrollView.frame.minX + 10,
//            y: scrollView.frame.minY + 10,
//            width: self.pictureSize.width + 20,
//            height: self.pictureSize.height
//        )
//
//        // setup scrollView
//
//        scrollView.contentSize = CGSize(width: self.pictureSize.width + 20, height: self.pictureSize.height)
//
//        //        scrollView.contentSize = CGSize(width: 1100, height: 680)
//
//        //        scrollView.backgroundColor = UIColor.yellow
//
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//
//        scrollView.bounces = false
//
//        // add subView
//        self.scrollView.addSubview(self.countryUIView)
//
//        self.view.addSubview(self.scrollView)
//
//        // zoom setting
//        scrollView.delegate = self
//        scrollView.zoomScale = 0.5
//        scrollView.minimumZoomScale = 0.5
//        scrollView.maximumZoomScale = 4.0
//
//        // scrollView constraints
//        let leading = NSLayoutConstraint(
//            item: scrollView,
//            attribute: .leading,
//            relatedBy: .equal,
//            toItem: view,
//            attribute: .leading,
//            multiplier: 1.0,
//            constant: 0.0
//        )
//
//        let top = NSLayoutConstraint(
//            item: scrollView,
//            attribute: .top,
//            relatedBy: .equal,
//            toItem: view,
//            attribute: .top,
//            multiplier: 1.0,
//            constant: 0.0
//        )
//
//        let trailing = NSLayoutConstraint(
//            item: scrollView,
//            attribute: .trailing,
//            relatedBy: .equal,
//            toItem: view,
//            attribute: .trailing,
//            multiplier: 1.0,
//            constant: 0.0
//        )
//
//        let bottom = NSLayoutConstraint(
//            item: scrollView,
//            attribute: .bottom,
//            relatedBy: .equal,
//            toItem: view,
//            attribute: .bottom,
//            multiplier: 1.0,
//            constant: 0.0
//        )
//
//        view.addConstraints([ leading, top, trailing, bottom ])
//        print("scrollviewsetup")
//    }
//
//    // 2.加了縮放功能 protocol (UIScrollViewDelegate) 需要implement 的function
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return  countryUIView
//    }
//
//        //3. 為了讓圖片縮小填滿且有Aspect Fit
//        fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
//            let widthScale = size.width /  countryUIView.bounds.width
//            let heightScale = size.height /  countryUIView.bounds.height
//
//            let minScale = min(widthScale, heightScale)
//            scrollView.minimumZoomScale = minScale
//
//            scrollView.zoomScale = minScale
//
//        }
//
//        //3. 呼叫
//        override func viewWillLayoutSubviews() {
//            super.viewDidLayoutSubviews()
//
//            updateMinZoomScaleForSize(view.bounds.size)
//
//        }
//
//    //4.讓圖片置中, 每次縮放之後會被呼叫
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//
//        let imageViewSize =  countryUIView.frame.size
//        let scrollViewSize = scrollView.bounds.size
//
//        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
//        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
//
//        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
//    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func calculatePictureBounds(rect: CGRect) {
        
        let maxX = rect.minX + rect.width
        let maxY = rect.minY + rect.height
        
        self.pictureSize.width = self.pictureSize.width > maxX ? self.pictureSize.width: maxX
        self.pictureSize.height = self.pictureSize.height > maxY ? self.pictureSize.height : maxY
    }
}
