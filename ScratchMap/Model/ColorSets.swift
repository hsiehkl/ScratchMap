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

    let coverColorSet = [
        UIColor(red: 148.0 / 255.0, green: 152.0 / 255.0, blue: 161.0 / 255.0, alpha: 1),
        UIColor(hue: 38/360, saturation: 40/100, brightness: 52/100, alpha: 1),
        UIColor(hue: 13/360, saturation: 46/100, brightness: 35/100, alpha: 1)
    ]

    let baseColorSet1 = [
        UIColor(red: 255.0 / 255.0, green: 146.0 / 255.0, blue: 139.0 / 255.0, alpha: 1),
        UIColor(red: 254.0 / 255.0, green: 195.0 / 255.0, blue: 166.0 / 255.0, alpha: 1),
        UIColor(red: 239.0 / 255.0, green: 233.0 / 255.0, blue: 174.0 / 255.0, alpha: 1)
    ]

    let baseColorSet2 = [
        UIColor(red: 204.0 / 255.0, green: 90.0 / 255.0, blue: 113.0 / 255.0, alpha: 1),
        UIColor(red: 200.0 / 255.0, green: 155.0 / 255.0, blue: 123.0 / 255.0, alpha: 1),
        UIColor(red: 240.0 / 255.0, green: 247.0 / 255.0, blue: 87.0 / 255.0, alpha: 1)
    ]

    let baseColorSet3 = [
        UIColor(red: 230.0 / 255.0, green: 175.0 / 255.0, blue: 46.0 / 255.0, alpha: 1),
        UIColor(red: 224.0 / 255.0, green: 226.0 / 255.0, blue: 219.0 / 255.0, alpha: 1),
        UIColor(red: 61.0 / 255.0, green: 52.0 / 255.0, blue: 139.0 / 255.0, alpha: 1)
    ]

    let baseColorSet4 = [
        UIColor(red: 255.0 / 255.0, green: 240.0 / 255.0, blue: 124.0 / 255.0, alpha: 1),
        UIColor(red: 128.0 / 255.0, green: 255.0 / 255.0, blue: 114.0 / 255.0, alpha: 1),
        UIColor(red: 126.0 / 255.0, green: 232.0 / 255.0, blue: 250.0 / 255.0, alpha: 1)
    ]

    let baseColorSet5 = [
        UIColor(red: 126.0 / 255.0, green: 232.0 / 255.0, blue: 250.0 / 255.0, alpha: 1),
        UIColor(red: 238.0 / 255.0, green: 192.0 / 255.0, blue: 198.0 / 255.0, alpha: 1),
        UIColor(red: 229.0 / 255.0, green: 240.0 / 255.0, blue: 138.0 / 255.0, alpha: 1)
    ]

    func colorSetProvider() -> [UIColor] {

        let colorSet = Int(arc4random_uniform(5) + 1)

        switch colorSet {

        case 1:
            print("colorSet1")
            return baseColorSet1

        case 2:
            print("colorSet2")
            return baseColorSet2

        case 3:
            print("colorSet3")
            return baseColorSet3

        case 4:
            print("colorSet4")
            return baseColorSet4

        case 5:
            print("colorSet5")
            return baseColorSet5

        default:
            print("colorSet Default")
            return baseColorSet4

        }
    }
}
