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

    @IBOutlet weak var cancelButtonImageView: UIImageView!
    @IBOutlet weak var scratchLabel: UILabel!
    @IBOutlet weak var cleanLabel: UILabel!
    @IBOutlet weak var checkButtonImageView: UIImageView!
    
    @IBOutlet weak var cleanButton: UIButton!
    @IBOutlet weak var showScratchableView: UIButton!
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

        self.view.backgroundColor = UIColor.clear
        dropShadow()
        setupCountryInfoContents()

    }
    
    override func viewDidLayoutSubviews() {

        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {

            hideButtons(isTrue: true)
            self.countryInfoView.frame = CGRect(x: 0, y: -20, width: self.view.frame.width, height: 80)

        } else {

            hideButtons(isTrue: false)
        }
    }
    
    func animate() {
        UIView.animate(withDuration: 1) {
            self.countryInfoView.frame = CGRect(x: 0, y: -20, width: self.countryInfoView.frame.width, height: self.countryInfoView.frame.height - 20
            )
        }
    }

    func dropShadow() {

        countryInfoView.layer.shadowColor = UIColor.gray.cgColor
        countryInfoView.layer.shadowOpacity = 0.6
        countryInfoView.layer.shadowOffset = CGSize.zero
        countryInfoView.layer.shadowRadius = 5
        self.countryInfoView.backgroundColor = UIColor.white.withAlphaComponent(0.8)

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
    
    func hideButtons(isTrue: Bool) {
        
        checkButtonImageView.isHidden = isTrue
        cancelButtonImageView.isHidden = isTrue
        scratchLabel.isHidden = isTrue
        cleanLabel.isHidden = isTrue
        
        showScratchableView.isEnabled = !isTrue
        cleanButton.isEnabled = !isTrue
        
    }

    @IBAction func scratchButtonTapped(_ sender: Any) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cratchableViewController = storyboard.instantiateViewController(withIdentifier: "scratchableViewController") as! ScratchViewController

        let country = Country(name: countryName, id: countryId, continent: continent, path: countryPath)
        cratchableViewController.country = country

        cratchableViewController.providesPresentationContextTransitionStyle = true
        cratchableViewController.definesPresentationContext = true
        cratchableViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        cratchableViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)

        cratchableViewController.delegate = parent as? MainPageViewController

        self.present(cratchableViewController, animated: true, completion: nil)

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

