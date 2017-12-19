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

class MainPageViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let mapContainerView = UIView()
    var paths = [SVGBezierPath]()
    var beenToCountries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollViewSetUp()
        svgWorldMapSetup()
        tapRecognizerSetup()
        fetchBeenToCountries()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.mapContainerView.layer.layoutIfNeeded()
        
        print("Layout: \(self.mapContainerView.frame)")
    }
    
    func svgWorldMapSetup() {
        
        let url = Bundle.main.url(forResource: "worldHigh", withExtension: "svg")!
        
        let paths = SVGBezierPath.pathsFromSVG(at: url)
        
        self.paths = paths
        
        for path in paths {
            
            // Create a layer for each path
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.fillColor = UIColor.gray.cgColor
            
            // Default Settings
            let strokeWidth = CGFloat(1.0)
            let strokeColor = UIColor.white.cgColor
            
            layer.lineWidth = strokeWidth
            layer.strokeColor = strokeColor
            
            self.mapContainerView.layer.addSublayer(layer)
        }
//        mapContainerView.layer.affineTransform()
        self.mapContainerView.layer.layoutSublayers()
        print("mapContainerView : \(self.mapContainerView.layer.bounds.size)")
    }
    
    func scrollViewSetUp() {
        
//        (0.0, 30.0, 320.0, 458.0)
//        scrollView.contentSize: (1030.0, 500.0)
        
        //(0.0, 30.0, 414.0, 626.0)
//        scrollView.contentSize: (1030.0, 500.0)
        
        scrollView.contentSize = CGSize(width: 1015, height: 700)
        
        scrollView.backgroundColor = UIColor.yellow
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.bounces = false
        
        mapContainerView.frame = CGRect(
            x: scrollView.frame.minX + 10,
            y: scrollView.frame.minY,
            width: 1030,
            height: 500 - 80
        )

        self.scrollView.addSubview(self.mapContainerView)
        
        self.view.addSubview(self.scrollView)
        
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
            constant: 30.0
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
            constant: -80.0
        )

        view.addConstraints([ leading, top, trailing, bottom ])
        
        view.layoutIfNeeded()
        
        print(scrollView.frame)
        print("scrollView.contentSize: \(scrollView.contentSize)")
        
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
            
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.fillColor = UIColor.red.cgColor
                
            let strokeWidth = CGFloat(1.0)
            let strokeColor = UIColor.blue.cgColor
                
            layer.lineWidth = strokeWidth
            layer.strokeColor = strokeColor
            self.mapContainerView.layer.addSublayer(layer)
            
            let ref = Database.database().reference()
            ref.keepSynced(true)
            let userInfo = ref.child("users").child("user01").child("beenToCountries").child("\(countryId)")
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
                
                let layer = CAShapeLayer()
                layer.path = beenToCountry.path.cgPath
                layer.fillColor = UIColor.gray.cgColor
                
                let strokeWidth = CGFloat(1.0)
                let strokeColor = UIColor.white.cgColor
                
                layer.lineWidth = strokeWidth
                layer.strokeColor = strokeColor
                self.mapContainerView.layer.addSublayer(layer)
                
                guard
                    let index = beenToCountries.index(of: beenToCountry)
                else {
                    break
                }
                
                let ref = Database.database().reference()
                ref.keepSynced(true)
                let countryRef = ref.child("users").child("user01").child("beenToCountries").child("\(id)")
                countryRef.removeValue()
                
                beenToCountries.remove(at: index)
                
                return false
            }
        }
        
        return true
    }
    
    func fetchBeenToCountries() {

        let ref = Database.database().reference()
        
        ref.child("users").child("user01").child("beenToCountries").observeSingleEvent(of: .value, with: { (snapshot) in
        
            ref.keepSynced(true)

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
                        
                        // Create a layer for each path
                        let layer = CAShapeLayer()
                        layer.path = path.cgPath
                        layer.fillColor = UIColor.red.cgColor
                        
                        // Default Settings
                        let strokeWidth = CGFloat(1.0)
                        let strokeColor = UIColor.blue.cgColor
                        
                        layer.lineWidth = strokeWidth
                        layer.strokeColor = strokeColor
                        
                        self.mapContainerView.layer.addSublayer(layer)
                        
                        self.beenToCountries.append(Country(name: countryName, id: countryId, path: path))
                        
                        print(self.beenToCountries.count)
                        
                    }
                }

            }
        })
        
    }
    
    func colorBeenToCountries() {
        
        
        
    }
    
    func calculateScaleFactor() -> CGFloat {
        
        let boundingBoxAspectRatio = scrollView.contentSize.width/scrollView.contentSize.height
        let viewAspectRatio = self.view.bounds.width/(self.view.bounds.height - 110)
        
        let scaleFactor: CGFloat
        if (boundingBoxAspectRatio > viewAspectRatio) {
            // Width is limiting factor
            scaleFactor = self.view.bounds.width/scrollView.contentSize.width
        } else {
            // Height is limiting factor
            scaleFactor = (self.view.bounds.height - 110)/scrollView.contentSize.height
        }
        
        return scaleFactor
        
//        let scaleFactor = transformRatio()
//
//        var affineTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
//
//        let transformedPath = (path.cgPath).copy(using: &affineTransform)
//
//        let layer = CAShapeLayer()
//        layer.path = transformedPath
        
    }
    
}
