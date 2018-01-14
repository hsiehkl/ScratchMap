//
//  AbbreviationProvider.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/14.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//

import Foundation

struct Abbreviation {
    
    static func abbreviation(countryName: String) -> String {
        
        if countryName.range(of: "Democratic Republic") != nil {
            
            let abbCountryName = countryName.replacingOccurrences(of: "Democratic Republic", with: "Dem. Rep.")
            
            return abbCountryName
        }
        
        return countryName
    }
    
}
