//
//  PrepareViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/19.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import Firebase

class PrepareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func fetchBeenToCountries() {
//        
//        let ref = Database.database().reference()
//        
//        ref.child("users").child("user01").child("beenToCountries").observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            //            ref.keepSynced(true)
//            
//            guard let dataValue = snapshot.value as? [String: String] else { return }
//            
//            for contryKey in dataValue.keys {
//                
//                for path in self.paths {
//                    
//                    guard let counrtyInfo = path.svgAttributes as? [String: String] else { return }
//                    
//                    guard
//                        let countryName = counrtyInfo["title"],
//                        let countryId = counrtyInfo["id"]
//                        
//                        else {
//                            
//                            let error = CountryInfoError.notFound
//                            
//                            print(error)
//                            
//                            return
//                    }
//                    
//                    if contryKey == countryId {
//                        
//                        self.colorSelectedCountry(path: path)
//                        
//                        self.beenToCountries.append(Country(name: countryName, id: countryId, path: path))
//                        
//                        print(self.beenToCountries.count)
//                        
//                    }
//                }
//                
//            }
//        })
//        
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
