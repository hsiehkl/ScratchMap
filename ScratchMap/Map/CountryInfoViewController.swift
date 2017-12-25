//
//  CountryInfoViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/25.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import FlagKit

class CountryInfoViewController: UIViewController {
    
    @IBOutlet weak var countryInfoView: UIView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    
    var countryName: String? {
        
        didSet {
            
            if countryNameLabel != nil {
                countryNameLabel.text = countryName
            }
            
            
        }
    }
    
    var countryId: String = ""
    {

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
        self.countryInfoView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        countryNameLabel.text = countryName

        guard let flag = Flag(countryCode: countryId) else { return }

        // Retrieve the unstyled image for customized use
        let originalImage = flag.originalImage

        // Or retrieve a styled flag
        let styledImage = flag.image(style: .circle)
        countryFlagImageView.image = styledImage

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
