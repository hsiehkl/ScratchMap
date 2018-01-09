//
//  ColorSets.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/31.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import ChameleonFramework

class ColorSet {

    func colorProvider(continent: String) -> [UIColor] {

        switch continent {

        case Continent.europe.rawValue:

            return [UIColor(red: 229.0 / 255.0, green: 177.0 / 255.0, blue: 136.0 / 255.0, alpha: 1), UIColor(red: 229.0 / 255.0, green: 177.0 / 255.0, blue: 136.0 / 255.0, alpha: 1)]

        case Continent.asia.rawValue:

            return [UIColor(red: 154.0 / 255.0, green: 193.0 / 255.0, blue: 160.0 / 255.0, alpha: 1), UIColor(red: 154.0 / 255.0, green: 193.0 / 255.0, blue: 160.0 / 255.0, alpha: 1)]

        case Continent.africa.rawValue:

            return [UIColor(red: 227.0 / 255.0, green: 161.0 / 255.0, blue: 160.0 / 255.0, alpha: 1), UIColor(red: 227.0 / 255.0, green: 161.0 / 255.0, blue: 160.0 / 255.0, alpha: 1)]

        case Continent.northAmerica.rawValue:

            return [UIColor(red: 227.0 / 255.0, green: 197.0 / 255.0, blue: 111.0 / 255.0, alpha: 1), UIColor(red: 227.0 / 255.0, green: 197.0 / 255.0, blue: 111.0 / 255.0, alpha: 1)]

        case Continent.southAmerica.rawValue:

            return [UIColor(red: 140.0 / 255.0, green: 193.0 / 255.0, blue: 188.0 / 255.0, alpha: 1), UIColor(red: 140.0 / 255.0, green: 193.0 / 255.0, blue: 188.0 / 255.0, alpha: 1)]

        case Continent.oceania.rawValue:

            return [UIColor(red: 239.0 / 255.0, green: 235.0 / 255.0, blue: 121.0 / 255.0, alpha: 1), UIColor(red: 239.0 / 255.0, green: 235.0 / 255.0, blue: 121.0 / 255.0, alpha: 1)]

        case Continent.europeAndAsia.rawValue:

            return  [UIColor(red: 229.0 / 255.0, green: 177.0 / 255.0, blue: 136.0 / 255.0, alpha: 1), UIColor(red: 154.0 / 255.0, green: 193.0 / 255.0, blue: 160.0 / 255.0, alpha: 1)]

        default:
            print("not in any of continent: \(continent)")
            return [UIColor.gray]

        }
    }
}
