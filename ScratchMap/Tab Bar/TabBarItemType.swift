//
//  TabBarItemType.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/16.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

//import Foundation
import UIKit

enum TabBarItemType {
    
    // MARK: Case
    
    case map, achievement
    
}

// MARK: - Title

extension TabBarItemType {
    
    var title: String {
        
        switch self {
            
        case .map:
            
            return "Map"
            
        case .achievement:
            
            return "Achievement"
        }
        
    }
    
}

// MARK: - Image

extension TabBarItemType {
    
    var image: UIImage {
        
        switch self {
            
        case .map:
            
            return #imageLiteral(resourceName: "maps-and-flags").withRenderingMode(.alwaysTemplate)
            
        case .achievement:
            
            return #imageLiteral(resourceName: "mapCheck").withRenderingMode(.alwaysTemplate)
            
            
        }
    }
    
}


