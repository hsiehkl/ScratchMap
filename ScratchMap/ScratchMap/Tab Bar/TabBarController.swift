//
//  ViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/17.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit

//class TabBarController: UITabBarController {
//
//    // MARK: Init
//    
//    init(itemTypes: [TabBarItemType]) {
//
//        super .init(nibName: nil, bundle: nil)
//
////        let viewControllers: [UIViewController] = itemTypes.map(
////
////            TabBarController.prepare
////
////        )
//
////        setViewControllers(viewControllers, animated: false)
//
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setUpTabBar()
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//
//    }
//    
//    // MARK: Set Up
//    
//    private func setUpTabBar() {
//        
//        tabBar.barStyle = .default
//        
//        tabBar.isTranslucent = false
//        
//        // Todo: palette
//        tabBar.tintColor = UIColor(
//            red: 53.0 / 255.0,
//            green: 184.0 / 255.0,
//            blue: 208 / 255.0,
//            alpha: 1.0
//        )
//        
//    }
//    
//    // MARK: Prepare Item Type
//    
//    func prepare(for itemType: TabBarItemType) -> UIViewController {
//        
//        switch itemType {
//            
//        case .map:
//            
//            let MainPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainPageViewController") as! MainPageViewController
//            
//            return MainPageViewController
//            
//        case .achievement:
//            
//            let MainPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainPageViewController") as! MainPageViewController
//            
//            return MainPageViewController
//
//        }
//        
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
