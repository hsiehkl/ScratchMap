//
//  DateTranslator.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/24.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//

import Foundation

class DateConverter {
    
    static func convertToShowingDate(date: Date)-> String {
        
        print("infunc \(date)")
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)

        return result
    }
    
    static func convertToUploadDate(date: Date)-> String {
        
        print("infunc22 \(date)")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let result = formatter.string(from: date)
        
        return result
    }
    
    static func convertDownloadDate(date: String)-> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        print("original\(date)")
        guard let date = dateFormatter.date(from: date) else { return "No time stamp." }
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let result = dateFormatter.string(from: date)
        return  result

    }
}
