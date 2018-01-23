//
//  DateTranslator.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/24.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//

import Foundation

class DateTranslator {
    
    static func translateIntoShowingDate(date: Date)-> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)

        return result
    }
    
    static func translateIntoUploadDate(date: Date)-> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let result = formatter.string(from: date)
        
        return result
    }
    
    static func translateIntoUploadDate(date: String)-> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        guard let date = dateFormatter.date(from: date) else { return "No time stamp." }
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let result = dateFormatter.string(from: date)
        return  result

    }
}
