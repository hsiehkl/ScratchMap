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

class MainPageViewController: UIViewController, UIScrollViewDelegate {
    
    private let scrollView = UIScrollView()
//    private let mapContainerView = UIView()
    private let mapContainerView = UIImageView()
    var paths = [SVGBezierPath]()
    var beenToCountries = [Country]()
    var pictureSize = CGSize.zero

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        checkUserStatus()
        svgWorldMapSetup()
        scrollViewSetUp()
        fetchBeenToCountries()
        tapRecognizerSetup()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func svgWorldMapSetup() {
        
        let url = Bundle.main.url(forResource: "worldHigh", withExtension: "svg")!
        
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
            y: scrollView.frame.minY + 10,
            width: self.pictureSize.width + 20,
            height: self.pictureSize.height
        )
        
        // setup scrollView
        
         scrollView.contentSize = CGSize(width: self.pictureSize.width + 20, height: self.pictureSize.height)
            
        
        
//        scrollView.contentSize = CGSize(width: 1100, height: 680)
        
        scrollView.backgroundColor = UIColor.yellow
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.bounces = false
        
        // add subView
        self.scrollView.addSubview(self.mapContainerView)
        
        self.view.addSubview(self.scrollView)
        
        // zoom setting
        scrollView.delegate = self
        scrollView.zoomScale = 0.5
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        
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
            constant: 20.0
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
    
//    }
    
//    //3. 呼叫
//    override func viewWillLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        updateMinZoomScaleForSize(view.bounds.size)
//
//    }

//    //4.讓圖片置中, 每次縮放之後會被呼叫
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        let imageViewSize =  mapContainerView.frame.size
//        let scrollViewSize = scrollView.bounds.size
//
//        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
//        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
//
//        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
//    }

    func tapRecognizerSetup() {
        
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.tapLocationDetected(tapRecognizer:))
        )
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    
    @objc public func tapLocationDetected(tapRecognizer: UITapGestureRecognizer) {
        
        let tapLocation: CGPoint = tapRecognizer.location(in: self.mapContainerView)
        
        self.colorSelectedCountry(tapLocation: CGPoint(x: tapLocation.x, y: tapLocation.y))
        
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
            let userInfo = ref.child("users").child(userId).child("beenToCountries").child("\(countryId)")
            let value = countryName
            userInfo.setValue(value)
            
            for color in self.beenToCountries {
                
                print("color1: \(color.id)")
                
            }

            self.beenToCountries.append(Country(name: countryName, id: countryId, path: path))
            
            for color in self.beenToCountries {
                
                print("color2: \(color.id)")
                
            }
            
            } else {
                
                continue
            }
        }
    }
    
    func countryHasNotBeingSelected(id: String) -> Bool {
        
        for beenToCountry in beenToCountries {
            
            if beenToCountry.id == id {
                
                colorNonSelectedCountry(path: beenToCountry.path)

                
                guard
                    let index = beenToCountries.index(of: beenToCountry)
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
                let countryRef = ref.child("users").child(userId).child("beenToCountries").child("\(id)")
                countryRef.removeValue()
                
                beenToCountries.remove(at: index)
                
                return false
            }
        }
        
        return true
    }
    
    func fetchBeenToCountries() {
        
        let user = Auth.auth().currentUser
        guard let userId = user?.uid else {
            // need to handle
            return
        }

        let ref = Database.database().reference()
        
        ref.child("users").child(userId).child("beenToCountries").observeSingleEvent(of: .value, with: { (snapshot) in
        
//            ref.keepSynced(true)

            guard let dataValue = snapshot.value as? [String: String] else { return }
        
            for contryKey in dataValue.keys {

                for path in self.paths {
                    
                    guard let counrtyInfo = path.svgAttributes as? [String: String] else { return }
                    
                    guard
                        let countryName = counrtyInfo["title"],
                        let countryId = counrtyInfo["id"]
                        
                        else {
                            
                            let error = CountryInfoError.notFound
                            
                            print(error)
                            
                            return
                    }
                    
                    if contryKey == countryId {
                        
                        self.colorSelectedCountry(path: path)
                        
                        self.beenToCountries.append(Country(name: countryName, id: countryId, path: path))
                        
                        print(self.beenToCountries.count)
                        
                    }
                }

            }
        })
        
    }
    
    func colorSelectedCountry(path: SVGBezierPath) {
        
        // Create a layer for each path
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.red.cgColor
        
        // Default Settings
        let strokeWidth = CGFloat(0.5)
        let strokeColor = UIColor.blue.cgColor
        
        layer.lineWidth = strokeWidth
        layer.strokeColor = strokeColor
        
        self.mapContainerView.layer.addSublayer(layer)
        
    }
    
    func colorNonSelectedCountry(path: SVGBezierPath) {
        
        // Create a layer for each path
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.gray.cgColor
        
        // Default Settings
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
    
//    func checkUserStatus() {
//
//        if Auth.auth().currentUser == nil {
//
//            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//
//            let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
//
//            self.present(loginViewController, animated: true, completion: nil)
//
//
//        } else {
//
//
//        }
//
//    }

    
}
