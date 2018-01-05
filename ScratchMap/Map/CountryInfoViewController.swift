//
//  CountryInfoViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/25.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import FlagKit
import PocketSVG

class CountryInfoViewController: UIViewController {
    
    @IBOutlet weak var countryInfoView: UIView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    
    var countryPath = SVGBezierPath()
    
    var continent: String = ""
    
    var countryName: String = "" {
        
        didSet {
            
            if countryNameLabel != nil {
                
                if countryName.range(of: "Democratic Republic") != nil {
                    
                    let abbCountryName = countryName.replacingOccurrences(of: "Democratic Republic", with: "Dem. Rep.")
                    
                    countryNameLabel.text = abbCountryName
                    
                } else {
                    countryNameLabel.text = countryName
                }
            }
        }
    }
    
    var countryId: String = "" {

        didSet {

            guard let flag = Flag(countryCode: countryId) else { return }

            let styledImage = flag.image(style: .circle)
            
            if countryFlagImageView != nil {
                countryFlagImageView.image = styledImage
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CountryInfoViewController: \(self.view.frame)")
        
        self.view.backgroundColor = UIColor.clear
        dropShadow()
        setupCountryInfoContents()
        
    }
    
    override func viewWillLayoutSubviews() {
        
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            
            countryInfoView.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 60)
            
        } else {
            
        }
    }

    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//
//        super.viewWillLayoutSubviews()
//
//        if UIDevice.current.orientation.isLandscape {
//            
//            print("Landscape")
//            
////            countryFlagImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//            
//
//        } else {
//
//            countryInfoView.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 70)
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dropShadow() {

        countryInfoView.layer.shadowColor = UIColor.gray.cgColor
        countryInfoView.layer.shadowOpacity = 0.6
        countryInfoView.layer.shadowOffset = CGSize.zero
        countryInfoView.layer.shadowRadius = 5
        self.countryInfoView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
    }


    @IBAction func showScratchableCountryView(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popOverVC = storyboard.instantiateViewController(withIdentifier: "scratchableViewController") as! ScratchViewController
        
//        popOverVC.countryPath = self.countryPath
        
        let country = Country(name: countryName, id: countryId, continent: continent, path: countryPath)
        popOverVC.country = country
        
        popOverVC.providesPresentationContextTransitionStyle = true
        popOverVC.definesPresentationContext = true
        popOverVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        popOverVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        popOverVC.delegate = parent as? MainPageViewController
        
        self.present(popOverVC, animated: true, completion: nil)
        
    }
    
    func setupCountryInfoContents() {
        
        countryNameLabel.text = countryName
        
        guard let flag = Flag(countryCode: countryId) else { return }
        
        let styledImage = flag.image(style: .circle)
        
        countryFlagImageView.image = styledImage
        
        countryFlagImageView.layer.shadowColor = UIColor.gray.cgColor
        
        countryFlagImageView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        
        countryFlagImageView.layer.shadowOpacity = 0.8
        
        countryFlagImageView.layer.shadowRadius = 2
        
        countryFlagImageView.layer.cornerRadius = countryFlagImageView.bounds.width / 2
    }
    
    @IBAction func scratchButtonTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popOverVC = storyboard.instantiateViewController(withIdentifier: "scratchableViewController") as! ScratchViewController
        
        //        popOverVC.countryPath = self.countryPath
        
        let country = Country(name: countryName, id: countryId, continent: continent, path: countryPath)
        popOverVC.country = country
        
        popOverVC.providesPresentationContextTransitionStyle = true
        popOverVC.definesPresentationContext = true
        popOverVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        popOverVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        popOverVC.delegate = parent as? MainPageViewController
        
        self.present(popOverVC, animated: true, completion: nil)
        
    }
    @IBAction func claenButtonTapped(_ sender: Any) {
        
        if let mainPageVC = self.parent as? MainPageViewController {
        
            mainPageVC.removeSelectedCountry(id: countryId)
        }
    }
        
    deinit {
        print("country view controller@@@@@")
    }
    
    
}
