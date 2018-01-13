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
    
    let title: String
    
    let location: String
    
    let image: UIImage
    
    let content: String
}

