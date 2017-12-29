//
//  DataModel.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/21.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import Foundation
import Firebase
import PocketSVG

protocol DataModelDelegate: class {
    
    func didReciveCountryData(_ provider: DataModel, visitedCountries: [Country])
}

class DataModel {
    
    weak var delegate: DataModelDelegate?

    var visitedCountries = [Country]()
    
    func requestData() {
        
        let url = Bundle.main.url(forResource: "worldHigh", withExtension: "svg")!
        
        let paths = SVGBezierPath.pathsFromSVG(at: url)
        
        visitedCountries = []
        
        let user = Auth.auth().currentUser
        guard let userId = user?.uid else {
            // need to handle
            return
        }
        
        let ref = Database.database().reference()
        
        ref.child("users").child(userId).child("visitedCountries").observeSingleEvent(of: .value, with: { (snapshot) in
            
            //            ref.keepSynced(true)
            
            guard let dataValue = snapshot.value as? [String: String] else { return }
            
            for contryKey in dataValue.keys {
                
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
                    
                    if contryKey == countryId {
                        
                        self.visitedCountries.append(Country(name: countryName, id: countryId, path: path))
                        
                    }
                }
            }
            
            self.delegate?.didReciveCountryData(self, visitedCountries: self.visitedCountries)
        })
    }
}
