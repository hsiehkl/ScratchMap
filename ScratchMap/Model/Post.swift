//
//  Post.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/11.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//

import Foundation
import UIKit

enum PostValidateError: Error {
    
    // MARK: Case
    
    case missingValue
    
}

struct Post {
    
    struct Schema {
        
        public static let title = "title"
        
        public static let content = "content"
        
        public static let imageUrl = "imageUrl"
        
        public static let date = "date"
        
    }
    
    let title: String
    
    //    let location: String?
    
    //    let image: UIImage
    
    let content: String
    
    let imageUrl: String
    
    let date: String
}
