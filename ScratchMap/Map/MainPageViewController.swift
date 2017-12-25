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

class MainPageViewController: UIViewController, UIScrollViewDelegate, DataModelDelegate {
    
    private let dataModel = DataModel()
    
    private let scrollView = UIScrollView()
    private let mapContainerView = UIView()
    var paths = [SVGBezierPath]()
    var visitedCountries = [Country]()
    var pictureSize = CGSize.zero
    var childViewHasAlreadyExisted = false
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Main____Page")
        
        dataModel.delegate = self
        dataModel.requestData()
        
        svgWorldMapSetup()
        scrollViewSetUp()
        tapRecognizerSetup()
//        setupCountryInfoView()
//        setupNavigationButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown //return the value as per the required orientation
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
//    override func viewWillDisappear(_ animated : Bool) {
//        super.viewWillDisappear(animated)
//        
//        if (self.isMovingFromParentViewController) {
//            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
//        }
//    }
//    
//    func canRotate() -> Void {}

    
    func svgWorldMapSetup() {
        
        let url = Bundle.main.url(forResource: "worldHigh", withExtension: "svg")!
        
        let paths = SVGBezierPath.pathsFromSVG(at: url)
        
        self.paths = paths
        
        for path in paths {
            
            self.calculatePictureBounds(rect: path.cgPath.boundingBox)
            
            colorNonSelectedCountry(path: path)
        }
        
        print("svgWorldMapSetup")
    }
    
    func scrollViewSetUp() {
        
        //setupMapContainerView
        
        mapContainerView.contentMode = .center
        mapContainerView.isUserInteractionEnabled = true
        
        mapContainerView.frame = CGRect(
            x: scrollView.frame.minX + 10,
            y: scrollView.frame.minY + 30,
            width: self.pictureSize.width + 20,
            height: self.pictureSize.height
        )
        
        // setup scrollView
        
         scrollView.contentSize = CGSize(width: self.pictureSize.width + 20, height: self.pictureSize.height)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.bounces = false
        
        // add subView
        self.scrollView.addSubview(self.mapContainerView)
        
        self.view.addSubview(self.scrollView)
        
        // zoom setting
        scrollView.delegate = self
        scrollView.zoomScale = 0.5
        scrollView.minimumZoomScale = 0.5
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
    
//    //3. 為了讓圖片縮小填滿且有Aspect Fit
//    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
//        let widthScale = size.width /  mapContainerView.bounds.width
//        let heightScale = size.height /  mapContainerView.bounds.height
//
//        let minScale = min(widthScale, heightScale)
//        scrollView.minimumZoomScale = minScale
//
//        scrollView.zoomScale = minScale
//    
//    }
//    
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
        
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.tapLocationDetected(tapRecognizer:))
        )
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    
    @objc public func tapLocationDetected(tapRecognizer: UITapGestureRecognizer) {
        
        let tapLocation: CGPoint = tapRecognizer.location(in: self.mapContainerView)
        
//        self.colorSelectedCountry(tapLocation: CGPoint(x: tapLocation.x, y: tapLocation.y))
        self.showCountryInfo(tapLocation: CGPoint(x: tapLocation.x, y: tapLocation.y))
    }
    
    func showCountryInfo(tapLocation: CGPoint) {
        
        var isTapInPath = false
        
        for path in paths {
            
            guard let counrtyInfo = path.svgAttributes as? [String: String] else { return }
            
            guard
                let countryName = counrtyInfo["title"],
                let countryId = counrtyInfo["id"]
                
                else {
                    
                    let error = CountryInfoError.notFound
                    
                    print(error)
                    
                    return
            }
            
            if path.contains(tapLocation) {
                
                isTapInPath = true
                
                if childViewHasAlreadyExisted {
                    
                    guard let countryInfoViewController = childViewControllers[0] as? CountryInfoViewController else { return }
                    
                    countryInfoViewController.countryName = countryName
                    countryInfoViewController.countryId = countryId
                    
                } else {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let popOverVC = storyboard.instantiateViewController(withIdentifier: "countryInfoViewController") as! CountryInfoViewController
                    
                    childViewHasAlreadyExisted = true
                    popOverVC.countryId = countryId
                    popOverVC.countryName = countryName
                    
                    self.addChildViewController(popOverVC)
                    
                    popOverVC.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 72)
                    self.view.addSubview(popOverVC.view)
                    popOverVC.didMove(toParentViewController: self)
                    
                }
            }
        }
        
        if !isTapInPath && childViewHasAlreadyExisted {
            
            childViewHasAlreadyExisted = false
            guard let countryInfoViewController = childViewControllers[0] as? CountryInfoViewController else { return }
            countryInfoViewController.view.removeFromSuperview()
            countryInfoViewController.removeFromParentViewController()
        }
    }

    private func colorSelectedCountry(tapLocation: CGPoint) {
        
        for path in paths {
            
            guard let counrtyInfo = path.svgAttributes as? [String: String] else { return }
            
            guard
                let countryName = counrtyInfo["title"],
                let countryId = counrtyInfo["id"]
                
                else {
                    
                    let error = CountryInfoError.notFound

                    print(error)
                    
                    return
            }
            
        if path.contains(tapLocation) && countryHasNotBeingSelected(id: countryId) {
            
            colorSelectedCountry(path: path)
            
            let user = Auth.auth().currentUser
            guard let userId = user?.uid else {
                // need to handle
                return
            }
            
            let ref = Database.database().reference()
//            ref.keepSynced(true)
            let userInfo = ref.child("users").child(userId).child("visitedCountries").child("\(countryId)")
            let value = countryName
            userInfo.setValue(value)

            self.visitedCountries.append(Country(name: countryName, id: countryId, path: path))
            
            print("selected: \(visitedCountries.count)")
            
            } else {
                
                continue
            }
        }
    }
    
    func countryHasNotBeingSelected(id: String) -> Bool {
        
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
                    return false
                }
                
                let ref = Database.database().reference()
                ref.keepSynced(true)
                let countryRef = ref.child("users").child(userId).child("visitedCountries").child("\(id)")
                countryRef.removeValue()
                
                visitedCountries.remove(at: index)
                
                return false
            }
        }
        
        return true
    }

    func colorSelectedCountry(path: SVGBezierPath) {
        
        // Create a layer for each path
        let layer = CAShapeLayer()
        layer.path = path.cgPath
//        let bounds = self.calculatePictureBounds(rect: path.cgPath.boundingBox)
        var pictureSizeTest = CGSize.zero
        let rect = path.cgPath.boundingBox
        let maxX = rect.minX + rect.width
        let maxY = rect.minY + rect.height
        
        pictureSizeTest.width = pictureSizeTest.width > maxX ? pictureSizeTest.width: maxX
        pictureSizeTest.height = pictureSizeTest.height > maxY ? pictureSizeTest.height : maxY
        
        let fillColor = 
            UIColor(gradientStyle: .leftToRight, withFrame: CGRect(x: rect.minX, y: rect.minY, width: pictureSizeTest.width, height: pictureSizeTest.height), andColors:
                [
                    UIColor(red: 71.0 / 255.0, green: 226.0 / 255.0, blue: 122.0 / 255.0, alpha: 0.7),

                    UIColor(red: 232.0 / 255.0, green: 254.0 / 255.0, blue: 151.0 / 255.0, alpha: 0.8)
                ])
        layer.fillColor = fillColor.cgColor
        
        // Default Settings
        let strokeWidth = CGFloat(0.5)
        let strokeColor = UIColor.black.cgColor
        
        layer.lineWidth = strokeWidth
        layer.strokeColor = strokeColor
        
        self.mapContainerView.layer.addSublayer(layer)
        
    }
    
    func colorNonSelectedCountry(path: SVGBezierPath) {
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 3)
//        layer.shadowOpacity = 1
        
        layer.fillColor = UIColor.gray.cgColor

        let strokeWidth = CGFloat(0.5)
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
    
    // conform protocol
    func didReciveCountryData(visitedCountries: [Country]) {
        
        self.visitedCountries = visitedCountries
        
        for visitedCountry in visitedCountries {
            
            colorSelectedCountry(path: visitedCountry.path)
        }
        
        print("visitedCountries: \(self.visitedCountries[0].name, self.visitedCountries[1].name)")
    }

    
    // NavigationBar setup
    func setupNavigationButton() {
        
        let gotToAchievementButton = UIBarButtonItem(image: #imageLiteral(resourceName: "mapCheck"), style: .plain, target: self, action: #selector(gotToAchievement(sender:)))

        self.navigationItem.rightBarButtonItem = gotToAchievementButton
        
    }
    
    @objc func gotToAchievement(sender: UIButton!) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let achievementViewController = storyboard.instantiateViewController(withIdentifier: "achievementViewController") as! AchievementViewController
        
        achievementViewController.visitedCountries = self.visitedCountries
        
        self.navigationController?.pushViewController(achievementViewController, animated: true)
        
    }
    
    func moceTextField(textField: UITextField, moveDistance: Int, up: Bool) {
        
    }
}
