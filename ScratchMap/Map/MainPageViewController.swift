//
//  ViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/15.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import PocketSVG
import Firebase
import ChameleonFramework
import FlagKit

class MainPageViewController: UIViewController, UIScrollViewDelegate {

    private let dataModel = DataModel()

    private let scrollView = UIScrollView()
    let mapContainerView = UIView()
    var paths = [SVGBezierPath]()
    var visitedCountries = [Country]()

    var pictureSize = CGSize.zero
    var childViewHasAlreadyExisted = false
    
    var tappedLayer: CAShapeLayer?
    var waterView: WaveView?
    
    let backgroundView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 246.0 / 255.0, green: 245.0 / 255.0, blue: 243.0 / 255.0, alpha: 1)

        dataModel.delegate = self
        dataModel.requestData()

        
        svgWorldMapSetup()
        scrollViewSetUp()
        tapRecognizerSetup()
        

    }
    
    @objc func canRotate() -> Void {}

    override func viewWillLayoutSubviews() {

        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            
            self.tabBarController?.tabBar.isHidden = true
            
        } else {

            self.tabBarController?.tabBar.isHidden = false
        }
    }
//
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//
////        let newView = UIView()
////        newView.backgroundColor = FlatBlack()
////        UIApplication.shared.keyWindow?.bringSubview(toFront: newView)
////        self.view.bringSubview(toFront: newView)
        
        let backgroundImage = UIImage(named: "backgroundLight")
        backgroundView.image = backgroundImage
        backgroundView.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: self.view.frame.height)
//        backgroundView.center = self.view.center
        self.scrollView.addSubview(backgroundView)
        
//
        let paperPlane = UIImage(named: "image-2")
        let paperPlaneView = UIImageView.init(image: paperPlane)
        paperPlaneView.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 60, height: 60)
        
        backgroundView.addSubview(paperPlaneView)
        
//        let circlePath = UIBezierPath(arcCenter: self.view.center, radius: 60, startAngle: 0, endAngle: .pi*2, clockwise: true)
//        let animation = CAKeyframeAnimation(keyPath: "position")
//        animation.duration = 2
//        animation.rotationMode = kCAAnimationRotateAuto
//        animation.repeatCount = MAXFLOAT
//        animation.path = circlePath.cgPath
//        paperPlaneView.layer.add(animation, forKey: "wave")
//
////        let line = UIView(frame: CGRect(x: -200, y: self.view.center.y, width: 150, height: 0.5))
////        line.backgroundColor = UIColor.black
////        self.scrollView.addSubview(line)
////
//        self.scrollView.addSubview(paperPlaneView)
////
//        func moveMapContainerView() {
//
//            UIView.animate(withDuration: 4.5, animations: {
//                self.mapContainerView.center.x += 1250
////                self.scrollView.transform = CGAffineTransform(scaleX: 2, y: 2)
//                paperPlaneView.center.x += 1250
////                line.center.x += 1500
////                paperPlaneView.center.y += 50 * sin(paperPlaneView.center.x)
////                paperPlaneView.center.x += paperPlaneView.frame.width/7
//                let size = self.view.bounds.size
//                let path: UIBezierPath = UIBezierPath()
//                path.lineCapStyle = .round
//                path.lineJoinStyle = .round
//
//                path.move(to: CGPoint(x: -1500, y: (size.height/2)))
//                path.addLine(to: CGPoint(x: 0, y: (size.height/2)))
//                path.addQuadCurve(to: CGPoint(x: size.width/3, y: (size.height/2)), controlPoint: CGPoint(x: size.width/6, y: size.height/3.2))
//                path.addQuadCurve(to: CGPoint(x: (size.width/3 * 2), y: (size.height/2)), controlPoint: CGPoint(x: (size.width/2), y: (size.height/3 * 1.7)))
//                path.addQuadCurve(to: CGPoint(x: (size.width), y: (size.height/2)), controlPoint: CGPoint(x: ((size.width/6 * 5)), y: (size.height/3.2)))
//
//
//
//                let animation = CAKeyframeAnimation(keyPath: "position")
//
//                animation.path = path.cgPath
//                animation.rotationMode = kCAAnimationRotateAuto
//                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//                            animation.repeatCount = MAXFLOAT
//                animation.duration = 3
//                paperPlaneView.layer.add(animation, forKey: "wave")
        
        
        let centerY = self.view.frame.height / 2  // find the vertical center
        let steps = 130               // Divide the curve into steps
        let stepX = self.view.frame.width / CGFloat(steps) // find the horizontal step distance
        // Make a path
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: centerY))
        // Loop and draw steps in straingt line segments
        for i in 0...steps {
            let x = CGFloat(i) * stepX
            let y = (sin(Double(i) * 0.1) * 40) + Double(centerY)
            path.addLine(to: CGPoint(x: x, y: CGFloat(y)))
        }

                        let animation = CAKeyframeAnimation(keyPath: "position")

                        animation.path = path.cgPath
                        animation.rotationMode = kCAAnimationRotateAuto
                        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                                    animation.repeatCount = MAXFLOAT
                        animation.duration = 3
                        paperPlaneView.layer.add(animation, forKey: "wave")
        
//        pathLayer.path = path.CGPath
//        pathLayer.lineWidth = 3
//        pathLayer.fillColor = UIColor.clearColor().CGColor
//        pathLayer.strokeColor = UIColor.redColor().CGColor
//        pathLayer.strokeStart = 0
//        pathLayer.strokeEnd = 0 // <<
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.fromValue = 0
//        animation.toValue = 1
//        animation.duration = 3
//        pathLayer.addAnimation(animation, forKey: "strokeEnd")
//            }, completion: { (true) in
//
//            })
//
//
////            let centerY = self.view.frame.height / 2  // find the vertical center
////            let steps = 200          // Divide the curve into steps
////            let stepX = self.view.frame.width / CGFloat(steps) // find the horizontal step distance
////            // Make a path
////            let path = UIBezierPath()
////            // Start in the lower left corner
////            path.move(to: CGPoint(x: 0, y: self.view.frame.height))
////            // Draw a line up to the vertical center
////            path.addLine(to: CGPoint(x: 0, y: centerY))
////            // Loop and draw steps in straingt line segments
////            for i in 0...steps {
////                let x = CGFloat(i) * stepX
////                let y = (sin(Double(i) * 0.1) * 40) + Double(centerY)
////                path.addLine(to: CGPoint(x: x, y: CGFloat(y)))
////            }
////            // Draw down to the lower right
////            path.addLine(to: CGPoint(x: self.view.frame.width, y: self.view.frame.height))
////            // Close the path
////            path.close()
////            // Render the path
////            let fillColor = UIColor.red
////            fillColor.setFill()
////            path.fill()
////            let path = UIBezierPath()
////            let size = self.view.bounds.size
////            let path: UIBezierPath = UIBezierPath()
////            path.lineCapStyle = .round
////            path.lineJoinStyle = .round
//////            path.move(to: CGPoint(x: size.width + 10, y: size.height))
//////            path.addLine(to: CGPoint(x: size.width + 10, y: size.height - 70))
//////            path.addQuadCurve(to: CGPoint(x: size.width/1.8, y: size.height - 70), controlPoint: CGPoint(x: size.width - 120, y: 200))
//////            path.addArc(withCenter: CGPoint(x: size.width/1.9, y: size.height - 140), radius: 70, startAngle: CGFloat(0.5*M_PI), endAngle: CGFloat(2.5*M_PI), clockwise: true)
//////            path.addCurve(to: CGPoint(x: 0, y: size.height - 100), controlPoint1: CGPoint(x: size.width/1.8 - 60, y: size.height - 60), controlPoint2: CGPoint(x: 150, y: size.height/2.3))
//////            path.addLine(to: CGPoint(x: -100, y: size.height + 10))
//////            path.move(to: (CGPoint(x: 16,y: 239)))
//////            path.addCurve(to: CGPoint(x: 301, y: 239), controlPoint1: CGPoint(x: 136, y: 373), controlPoint2: CGPoint(x: 178, y: 110))
////
//////            path.move(to: CGPoint(x: -100, y: (size.height/2 - 30)))
//////            path.addQuadCurve(to: CGPoint(x: size.width/2.7, y: (size.height/2 + 50)), controlPoint: CGPoint(x: size.width/2.2, y: size.height/2.5))
//////            path.addQuadCurve(to: CGPoint(x: size.width/1.3, y: (size.height/2.3)), controlPoint: CGPoint(x: size.width/1.9, y: size.height/1.6))
//////            path.addQuadCurve(to: CGPoint(x: size.width + 60, y: (size.height/2)), controlPoint: CGPoint(x: size.width, y: size.height/1.6))
////
////
////            path.move(to: CGPoint(x: -1500, y: (size.height/2)))
////            path.addLine(to: CGPoint(x: 0, y: (size.height/2)))
////            path.addQuadCurve(to: CGPoint(x: size.width/3, y: (size.height/2)), controlPoint: CGPoint(x: size.width/6, y: size.height/3))
////            path.addQuadCurve(to: CGPoint(x: (size.width/3 * 2), y: (size.height/2)), controlPoint: CGPoint(x: (size.width/2), y: (size.height/3 * 2)))
////            path.addQuadCurve(to: CGPoint(x: (size.width), y: (size.height/2)), controlPoint: CGPoint(x: ((size.width/6 * 5)), y: (size.height/3)))
////
////
////
////            let animation = CAKeyframeAnimation(keyPath: "position")
////
////            animation.path = path.cgPath
////            animation.rotationMode = kCAAnimationRotateAuto
//////            animation.repeatCount = c
////            animation.duration = 2.5
////            paperPlaneView.layer.add(animation, forKey: "wave")
//        }
//        moveMapContainerView()
    }


    func svgWorldMapSetup() {

        let url = Bundle.main.url(forResource: "worldHighNew", withExtension: "svg")!

        let paths = SVGBezierPath.pathsFromSVG(at: url)

        self.paths = paths

        for path in paths {

            self.calculatePictureBounds(rect: path.cgPath.boundingBox)

            colorNonSelectedCountry(path: path)
        }
    }

    func scrollViewSetUp() {

        //setupMapContainerView

        mapContainerView.contentMode = .center
        mapContainerView.isUserInteractionEnabled = true

        mapContainerView.frame = CGRect(
            x: scrollView.frame.minX + 10,
            y: scrollView.frame.minY + 30,
            width: self.pictureSize.width + 30,
            height: self.pictureSize.height + 30
        )
        
//        mapContainerView.frame = CGRect(
//            x: -1250,
//            y: scrollView.frame.minY + 30,
//            width: (self.pictureSize.width + 30),
//            height: (self.pictureSize.height + 30)
//        )

        // setup scrollView

        scrollView.contentSize = CGSize(width: self.pictureSize.width + 20, height: self.pictureSize.height)

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.bounces = false

        // add subView
//        self.scrollView.addSubview(self.mapContainerView)

        self.view.addSubview(self.scrollView)

        // zoom setting
        scrollView.delegate = self
        scrollView.zoomScale = 0.5
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 4.0

        // scrollView constraints
        let leading = NSLayoutConstraint(
            item: scrollView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: view,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0.0
        )

        let top = NSLayoutConstraint(
            item: scrollView,
            attribute: .top,
            relatedBy: .equal,
            toItem: view,
            attribute: .top,
            multiplier: 1.0,
            constant: 0.0
        )

        let trailing = NSLayoutConstraint(
            item: scrollView,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: view,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0.0
        )

        let bottom = NSLayoutConstraint(
            item: scrollView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: view,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0.0
        )

        view.addConstraints([ leading, top, trailing, bottom ])
        print("scrollviewsetup")
    }

    // 2.加了縮放功能 protocol (UIScrollViewDelegate) 需要implement 的function
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return  mapContainerView
    }

    //3. 為了讓圖片縮小填滿且有Aspect Fit
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width /  mapContainerView.bounds.width
        let heightScale = size.height /  mapContainerView.bounds.height

        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale

        scrollView.zoomScale = minScale
    
    }

//    //3. 呼叫
//    override func viewWillLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        updateMinZoomScaleForSize(view.bounds.size)
//
//    }

    //4.讓圖片置中, 每次縮放之後會被呼叫
    func scrollViewDidZoom(_ scrollView: UIScrollView) {

        let imageViewSize =  mapContainerView.frame.size
        let scrollViewSize = scrollView.bounds.size

        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0

        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }

    func tapRecognizerSetup() {

        let singleTapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.tapLocationDetected(tapRecognizer:))
        )

        singleTapRecognizer.numberOfTapsRequired = 1

        self.view.addGestureRecognizer(singleTapRecognizer)
    }

    @objc public func tapLocationDetected(tapRecognizer: UITapGestureRecognizer) {

        let tapLocation: CGPoint = tapRecognizer.location(in: self.mapContainerView)

        self.showCountryInfo(tapLocation: CGPoint(x: tapLocation.x, y: tapLocation.y))
    }

    func showCountryInfo(tapLocation: CGPoint) {

        var isTapInCountryPath = false

        for path in paths {

            guard let countryInfo = path.svgAttributes as? [String: String] else { return }

            guard
                let countryName = countryInfo["title"],
                let countryId = countryInfo["id"],
                let continent = countryInfo["continent"]

                else {

                    let error = CountryInfoError.notFound

                    print(error)

                    return
            }

            if path.contains(tapLocation) {
//
//                var mask = UIView()
//                var wantToShowView = UIView()
//                var scratchCardView: ScratchCardView?
//
//                mask.frame = self.view.frame
//                wantToShowView.frame = self.view.frame
//
//                let layer = CAShapeLayer()
//
//                layer.path = path.cgPath
//                layer.fillColor = FlatGray().cgColor
//
//                let strokeWidth = CGFloat(0.5)
//                let strokeColor = UIColor.white
//
//                layer.lineWidth = strokeWidth
//                layer.strokeColor = strokeColor.cgColor
//                layer.shadowColor = UIColor.black.cgColor
//                layer.shadowOpacity = 0.7
//                layer.shadowOffset = CGSize(width: 0.0, height: 15.0)
//
//                wantToShowView.layer.addSublayer(layer)
//
//                scratchCardView = ScratchCardView(frame: self.view.frame)
//
//                scratchCardView!.setupWith(coverView: mask, contentView: wantToShowView)
//                self.view.addSubview(scratchCardView!)
//

                isTapInCountryPath = true

                if childViewHasAlreadyExisted {

                    removeShadowLayer()
                    addShadowOnTappedPath(path: path, continent: continent, id: countryId)

                    guard let countryInfoViewController = childViewControllers[0] as? CountryInfoViewController else { return }

                    countryInfoViewController.countryName = countryName
                    countryInfoViewController.countryId = countryId
                    countryInfoViewController.countryPath = path
                    countryInfoViewController.continent = continent

                } else {

                    addShadowOnTappedPath(path: path, continent: continent, id: countryId)
                    
                    childViewHasAlreadyExisted = true
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let countryInfoViewController = storyboard.instantiateViewController(withIdentifier: "countryInfoViewController") as! CountryInfoViewController

                    countryInfoViewController.countryId = countryId
                    countryInfoViewController.countryName = countryName
                    countryInfoViewController.countryPath = path
                    countryInfoViewController.continent = continent

                    self.addChildViewController(countryInfoViewController)

                    countryInfoViewController.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 80)
                    
                    self.view.addSubview(countryInfoViewController.view)
                    countryInfoViewController.didMove(toParentViewController: self)

                }
            }
        }

        if !isTapInCountryPath && childViewHasAlreadyExisted {

            childViewHasAlreadyExisted = false
            
            removeShadowLayer()
            
            guard let countryInfoViewController = childViewControllers[0] as? CountryInfoViewController else { return }
            countryInfoViewController.view.removeFromSuperview()
            countryInfoViewController.removeFromParentViewController()
        }
    }
    
    func removeShadowLayer() {

        guard
            let tappedLayer = self.tappedLayer,
            let index = mapContainerView.layer.sublayers?.index(of: tappedLayer)
        else { return }
        
        mapContainerView.layer.sublayers?.remove(at: index)
    }
    
    func addShadowOnTappedPath(path: SVGBezierPath, continent: String, id: String) {
        
        let tappedLayer = CAShapeLayer()
        tappedLayer.path = path.cgPath
        
        tappedLayer.shadowColor = UIColor.black.cgColor
        tappedLayer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        tappedLayer.shadowOpacity = 0.7
        tappedLayer.shadowRadius = 8
        
        let rect = path.cgPath.boundingBox
        let maxX = rect.minX + rect.width
        let maxY = rect.minY + rect.height
        
        let strokeWidth = CGFloat(0.4)
        let strokeColor = UIColor.white.cgColor
        
        tappedLayer.lineWidth = strokeWidth
        tappedLayer.strokeColor = strokeColor
        
        if countryHasNotBeenSelected(id: id) {
            
            let fillColor =
                UIColor(gradientStyle: .leftToRight, withFrame: CGRect(x: rect.minX, y: rect.minY, width: maxX, height: maxY), andColors:
                    
                    [UIColor.gray, UIColor.gray]
            )
            
            tappedLayer.fillColor = fillColor.cgColor
            
            self.tappedLayer = tappedLayer
            
            self.mapContainerView.layer.addSublayer(tappedLayer)
            
        } else {
            
            let fillColor =
                UIColor(gradientStyle: .leftToRight, withFrame: CGRect(x: rect.minX, y: rect.minY, width: maxX, height: maxY), andColors:
                    
                    classifyContinent(continent: continent)
            )
            
            tappedLayer.fillColor = fillColor.cgColor
            
            self.tappedLayer = tappedLayer
            
            self.mapContainerView.layer.addSublayer(tappedLayer)
            
        }
    }

    private func colorSelectedCountry(country: Country) {

        if countryHasNotBeenSelected(id: country.id) {

            guard let continent = country.continent else { return }

            colorThePath(path: country.path, continent: continent)

            let user = Auth.auth().currentUser
            guard let userId = user?.uid else {
                // need to handle
                return
            }

            let ref =  Database.database().reference()
            ref.keepSynced(true)
            let userInfo = ref.child("users").child(userId).child("visitedCountries").child("\(country.id)")

            let value = country.name
            userInfo.setValue(value)

            self.visitedCountries.append(Country(name: country.name, id: country.id, continent: country.continent, path: country.path))
        }
    }

    func countryHasNotBeenSelected(id: String) -> Bool {

        for visitedCountry in visitedCountries {

            if visitedCountry.id == id {

                return false
            }
        }

        return true
    }

    func removeSelectedCountry(id: String) {

        for visitedCountry in visitedCountries {

            if visitedCountry.id == id {

                colorNonSelectedCountry(path: visitedCountry.path)

                guard
                    let index = visitedCountries.index(of: visitedCountry)
                    else {
                        break
                }

                let user = Auth.auth().currentUser
                guard let userId = user?.uid else {
                    // need to handle
                    return
                }

                let ref = Database.database().reference()
                ref.keepSynced(true)
                
                let countryRef = ref.child("users").child(userId).child("visitedCountries").child("\(id)")
                countryRef.removeValue()

                visitedCountries.remove(at: index)

            }
        }
    }

    func classifyContinent(continent: String) -> [UIColor] {

        let colorSet = ColorSet()

        return colorSet.colorProvider(continent: continent)
    }

    func colorThePath(path: SVGBezierPath, continent: String) {

        let layer = CAShapeLayer()
        layer.path = path.cgPath

        let rect = path.cgPath.boundingBox
        let maxX = rect.minX + rect.width
        let maxY = rect.minY + rect.height

        let fillColor =
            UIColor(gradientStyle: .leftToRight, withFrame: CGRect(x: rect.minX, y: rect.minY, width: maxX, height: maxY), andColors:

                    classifyContinent(continent: continent)

                )

        layer.fillColor = fillColor.cgColor

        let strokeWidth = CGFloat(0.4)
        let strokeColor = UIColor.black.cgColor

        layer.lineWidth = strokeWidth
        layer.strokeColor = strokeColor

        self.mapContainerView.layer.addSublayer(layer)
    }

    func colorNonSelectedCountry(path: SVGBezierPath) {

        let layer = CAShapeLayer()

        layer.path = path.cgPath

        layer.fillColor = UIColor.gray.cgColor

        let strokeWidth = CGFloat(0.3)
        let strokeColor = UIColor.white.cgColor

        layer.lineWidth = strokeWidth
        layer.strokeColor = strokeColor

        self.mapContainerView.layer.addSublayer(layer)

    }

    func calculatePictureBounds(rect: CGRect) {

        let maxX = rect.minX + rect.width
        let maxY = rect.minY + rect.height

        self.pictureSize.width = self.pictureSize.width > maxX ? self.pictureSize.width: maxX
        self.pictureSize.height = self.pictureSize.height > maxY ? self.pictureSize.height : maxY
    }

//    func moceTextField(textField: UITextField, moveDistance: Int, up: Bool) {
//
//    }
    
    deinit {
        print("main page controller@@@@@")
    }

}

extension MainPageViewController: ScratchViewControllerDelegate, DataModelDelegate {

    func didReciveCountryData(_ provider: DataModel, visitedCountries: [Country]) {

//        self.scrollView.addSubview(self.mapContainerView)
        
//        animation()
        
        self.visitedCountries = visitedCountries

        for visitedCountry in visitedCountries {

            guard let continent = visitedCountry.continent else { return }

            colorThePath(path: visitedCountry.path, continent: continent)

        }
    }
    
    func animation() {
        UIView.animate(withDuration: 2) {
            self.backgroundView.alpha = 0
        }
        
        backgroundView.removeFromSuperview()
    }

    func didReciveScratchedCountry(_ provider: ScratchViewController, scratchedCountry: Country) {

        removeShadowLayer()
        colorSelectedCountry(country: scratchedCountry)
        
    }
}
