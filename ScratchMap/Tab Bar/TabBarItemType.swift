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

            return NSLocalizedString("Map", comment: "")

        case .achievement:

            return NSLocalizedString("Achievement", comment: "")
        }

    }

}

// MARK: - Image

extension TabBarItemType {

    var image: UIImage {

        switch self {

        case .map:

            return #imageLiteral(resourceName: "non-map").withRenderingMode(.alwaysOriginal)

        case .achievement:

            return #imageLiteral(resourceName: "non-achievement").withRenderingMode(.alwaysOriginal)
        }
    }

    var selectedImage: UIImage? {

        switch self {

        case .map:

            return #imageLiteral(resourceName: "tryMap").withRenderingMode(.alwaysOriginal)

        case .achievement:

            return #imageLiteral(resourceName: "newSize").withRenderingMode(.alwaysOriginal)
        }

    }

}
