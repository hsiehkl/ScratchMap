//
//  ScratchViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/26.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import PocketSVG
import AudioToolbox
import ChameleonFramework

protocol ScratchViewControllerDelegate: class {
    func didReciveScratchedCountry(_ provider: ScratchViewController, scratchedCountry: Country)
    func didRemoveCountry(_ provider: ScratchViewController, scratchedCountry: Country)
}

class ScratchViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!

    var mask = UIView()
    var wantToShowView = UIView()

    weak var delegate: ScratchViewControllerDelegate?
    var scratchCardView: ScratchCardView?

    var country: Country = Country(name: "", id: "", continent: "", path: SVGBezierPath())

    let colorSet = ColorSet()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mask.frame = self.view.frame
        wantToShowView.frame = self.view.frame

        let maskFillColor = UIColor.gray

        guard let continent = country.continent else { return }

        let baseFillColor = UIColor(gradientStyle: .leftToRight, withFrame: wantToShowView.frame, andColors:
                colorSet.colorProvider(continent: continent)
        )

        let scaleTransformedPath = transformPathScale(path: country.path)

        let translateTransformedPath = transformPathTranslation(scaleTransformedPath: scaleTransformedPath)

        setupCountryLayerOnUIView(path: translateTransformedPath, continentColor: baseFillColor, parentView: wantToShowView)

        setupCountryLayerOnUIView(path: translateTransformedPath, continentColor: maskFillColor, parentView: mask)

        setupScratchableView()
        
    }

    override func viewWillLayoutSubviews() {

        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {

        } else {

            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    public func setupScratchableView() {

        scratchCardView = ScratchCardView(frame: self.view.frame)

        scratchCardView!.setupWith(coverView: mask, contentView: wantToShowView)
        self.view.addSubview(scratchCardView!)

        doneButton.layer.cornerRadius = 10
        doneButton.layer.shadowColor = UIColor.black.cgColor
        doneButton.layer.shadowRadius = 10
        doneButton.layer.shadowOpacity = 0.8
        doneButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.scratchCardView?.addSubview(doneButton)

    }

    func setupCountryLayerOnUIView(path: CGPath, continentColor: UIColor, parentView: UIView) {

        let layer = CAShapeLayer()

        layer.path = path
        layer.fillColor = continentColor.cgColor

        let strokeWidth = CGFloat(0.5)
        let strokeColor = UIColor.white

        layer.lineWidth = strokeWidth
        layer.strokeColor = strokeColor.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 0.0, height: 15.0)

        parentView.layer.addSublayer(layer)

    }

    func transformPathScale(path: UIBezierPath) -> CGPath {

        let pathBoundingBox = path.cgPath.boundingBox

        let boundingBoxAspectRatio = pathBoundingBox.width/pathBoundingBox.height

        print("boundingBoxAspectRatio: \(pathBoundingBox.width), \(pathBoundingBox.height)")

        var viewAspectRatio: CGFloat = 1

        var scaleFactor: CGFloat = 1.0

        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {

            viewAspectRatio = (self.view.frame.width-400)/(self.view.frame.height-100)

            if (boundingBoxAspectRatio > viewAspectRatio) {
                // Width is limiting factor
                scaleFactor = (self.view.frame.width-400)/pathBoundingBox.width
            } else {
                // Height is limiting factor
                scaleFactor = (self.view.frame.height-100)/pathBoundingBox.height
            }

        } else {

            viewAspectRatio = (self.view.frame.width-60)/(self.view.frame.height-300)

            if (boundingBoxAspectRatio > viewAspectRatio) {
                // Width is limiting factor
                scaleFactor = (self.view.frame.width-60)/pathBoundingBox.width
            } else {
                // Height is limiting factor
                scaleFactor = (self.view.frame.height-300)/pathBoundingBox.height
            }
        }

        var scaleTransform = CGAffineTransform.identity

        scaleTransform = scaleTransform.scaledBy(x: scaleFactor * 0.8, y: scaleFactor * 0.8)

        guard let scaleTransformedPath = (path.cgPath).copy(using: &scaleTransform) else { return path.cgPath }

        return scaleTransformedPath
    }

    func transformPathTranslation(scaleTransformedPath: CGPath) -> CGPath {

        let scaledPathBoundingBox = scaleTransformedPath.boundingBox

        let shiftUpConstance = self.view.frame.height * 0.05

        let viewCenterX = view.center.x
        let viewCenterY = view.center.y - shiftUpConstance

        let centerOffset = CGSize(width: -(scaledPathBoundingBox.midX-viewCenterX), height: -(scaledPathBoundingBox.midY-viewCenterY))

        var translateTransform = CGAffineTransform.identity
        translateTransform = translateTransform.translatedBy(x: centerOffset.width, y: centerOffset.height)

        guard let translateTransformedPath = (scaleTransformedPath).copy(using: &translateTransform) else { return scaleTransformedPath }

        return translateTransformedPath

    }

    @IBAction func doneButtonTapped(_ sender: Any) {

        self.delegate?.didReciveScratchedCountry(self, scratchedCountry: country)
        self.dismiss(animated: true, completion: nil)

    }

    deinit {
        print("Scratchable View@@@@")
    }
}
