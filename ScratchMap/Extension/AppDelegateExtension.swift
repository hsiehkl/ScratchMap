//
//  AppDelegateExtension.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/26.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate {

    class var shared: AppDelegate {

        return UIApplication.shared.delegate as! AppDelegate

    }
}
