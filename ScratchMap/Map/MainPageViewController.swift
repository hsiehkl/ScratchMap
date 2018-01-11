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
        let strokeColor = UIColor.white.cgColor

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

        self.visitedCountries = visitedCountries

        for visitedCountry in visitedCountries {

            guard let continent = visitedCountry.continent else { return }

            colorThePath(path: visitedCountry.path, continent: continent)

        }
    }

    func didReciveScratchedCountry(_ provider: ScratchViewController, scratchedCountry: Country) {

        removeShadowLayer()
        colorSelectedCountry(country: scratchedCountry)
    }
}
