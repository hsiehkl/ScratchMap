//
//  ViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/17.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//
import Foundation
import UIKit

class TabBarController: UITabBarController {

    // MARK: Init

    init(itemTypes: [TabBarItemType]) {

        super .init(nibName: nil, bundle: nil)

        let viewControllers: [UIViewController] = itemTypes.map(

            TabBarController.prepare

        )

        setViewControllers(viewControllers, animated: false)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        setUpTabBar()
        setupBarItemFont()

    }

    // MARK: Set Up

    private func setUpTabBar() {

        tabBar.barStyle = .default

        tabBar.isTranslucent = false

        // Todo: palette
        tabBar.barTintColor = UIColor(
            red: 132.0 / 255.0, green: 191.0 / 255.0, blue: 230.0 / 255.0, alpha: 1)

    }

    // MARK: Prepare Item Type

    static func prepare(for itemType: TabBarItemType) -> UIViewController {
        
        let font = UIFont(name: "Avenir-Light", size: 20)
        let textAttributes = [NSAttributedStringKey.font: font]

        switch itemType {

        case .map:

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainPageViewController = storyboard.instantiateViewController(withIdentifier: "mainPageViewController") //as! MainPageViewController

            mainPageViewController.tabBarItem = TabBarItem(
                itemType: itemType
            )

            return mainPageViewController

        case .achievement:

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let achievementViewController = storyboard.instantiateViewController(withIdentifier: "achievementViewController") //as! AchievementViewController

            let achievementNavigationController = UINavigationController(rootViewController: achievementViewController)

            achievementNavigationController.navigationBar.titleTextAttributes = textAttributes

            achievementNavigationController.tabBarItem = TabBarItem(itemType: itemType)

            return achievementNavigationController
            
        case .journey:
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newsFeedViewController = storyboard.instantiateViewController(withIdentifier: "newsFeedViewController") //as! NewsFeedViewController
            
            let newsFeedNavigationController = UINavigationController(rootViewController: newsFeedViewController)
            
            newsFeedNavigationController.navigationBar.titleTextAttributes = textAttributes
            
            newsFeedNavigationController.tabBarItem = TabBarItem(itemType: itemType)
            
            return newsFeedNavigationController

        }

    }

    func setupBarItemFont() {

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Avenir-Light", size: 12)!], for: .normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Avenir-Light", size: 12)!], for: .selected)
    }
}

extension UITabBarController {
    
    func hideTabBarAnimitaed(hide: Bool) {
        
        let translateTransform = CGAffineTransform.identity
        
        if hide {
            
            UIView.animate(withDuration: 0) {
                
                self.tabBar.transform = translateTransform.translatedBy(x: 0, y: 50)
            }
                
        } else {
                
            UIView.animate(withDuration: 0.5) {
                
                self.tabBar.transform = translateTransform
            }
        }
    }
}
