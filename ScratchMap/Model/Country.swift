//
//  Country.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/15.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import Foundation
import PocketSVG

// MARK: CountryInfoError

enum CountryInfoError: Error {
    
    case notFound
    
}

struct Country {
    
     // MARK: Property
    
    let name: String
    
    let id: String
    
    let path: SVGBezierPath
    
}

extension Country: Equatable {
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        
        return
            
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.path == rhs.path
        
    }
}

