//
//  AchievementViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/17.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import FirebaseAuth

class AchievementViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
//    private let dataModel = DataModel()
    var visitedCountries = [Country]()
    let continents = ["Europe", "Asia", "Africa", "North America", "South America", "Oceania"]
    var countries: [String: [Country]] = ["Europe": [], "Asia": [], "Africa": [], "North America": [], "South America": [], "Oceania": []]
    let progressBar = ProgressBarView()

    @IBOutlet weak var worldAchievementLabel: UILabel!
    @IBOutlet weak var logoutButtonOutlet: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Achievement_______Page")
        
//        dataModel.delegate = self
        
        setupNavigationBar()
        
        catchMainPage()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        dataModel.requestData()
        catchMainPage()
        
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        let screenWidth = UIScreen.main.bounds.width - 20
        let screenHeight = UIScreen.main.bounds.height
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 10)
            
            let padding: CGFloat = 10
            let itemWidth = screenWidth/3 - padding
            let itemHeight = (screenHeight)/2 + (padding * 3)
            
            print("\(itemWidth),\(itemHeight)")
            
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            
            collectionView.collectionViewLayout = layout
        
        } else {
            
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
            
            let padding: CGFloat = 5
            let itemWidth = screenWidth/2 - padding
            let itemHeight = screenHeight/3 + padding

            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            
            collectionView.collectionViewLayout = layout
        }
        
        layout.invalidateLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
     return continents.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "achievementCollectionViewCell", for: indexPath) as! AchievementCollectionViewCell
            
        
            cell.imageView.image = UIImage(named: "\(continents[indexPath.row])-1")
        
            let continentCountryAmount = continentCountryCount()
        
            let key = continents[indexPath.row]
        
            if let progressAmount = countries[key]?.count {

//            cell.progressLabel.text = "\(progress)/\(continentCountryAmount[indexPath.row])"
                
            cell.continentLabel.text = "\(continents[indexPath.row]) \(progressAmount)/\(continentCountryAmount[indexPath.row])"
                
            let progress = CGFloat(progressAmount)/CGFloat(continentCountryAmount[indexPath.row])
                
                print("check: \(key)\(progress)!!!!")
                
            cell.continentProgressBarView.progress = progress
                
            let percentage = progress * 100
            cell.continentPercentageLabel.text = "\(String(format: "%.0f", percentage))%"
                
            }
        
            
        
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "worldHeader", for: indexPath) as! WorldCollectionReusableView
            
            let totalCountryAmount = continentCountryCount().reduce(0) { $0 + $1 }
            
            headerView.worldProgressLabel.text = "World \(visitedCountries.count)/\(totalCountryAmount)"
            
            let progress = CGFloat(visitedCountries.count)/CGFloat(totalCountryAmount)
            headerView.progressBarView.progress = progress
            let percentage = progress * 100
            print(" progreeeeeeee \(String(format: "%.2f", percentage))")
            headerView.worldPercentageLabel.text = "\(String(format: "%.0f", percentage))%"
            
            return headerView
        default:
            assert(false, "Unxpected element kind")
        }
    }
    
    func classified() {
        
        countries = ["Europe": [], "Asia": [], "Africa": [], "North America": [], "South America": [], "Oceania": []]

        for visitedCountry in visitedCountries {
            
            let countryId = visitedCountry.id
            
            for (key, value) in countryIdClassifiedByContinents {
                
                for contry in value {
                    
                    if contry == countryId {
                        
                        countries[key]?.append(visitedCountry)
                    }
                }
            }
        }
    }
    
    func continentCountryCount() -> [Int] {
        
        var continentCountryAmount: [Int] = []
        
        for contient in continents {
            
            if let value = countryIdClassifiedByContinents[contient] {
                continentCountryAmount.append(value.count)
            }
        }
        
        return continentCountryAmount
    }
    
//    @IBAction func logoutTapped(_ sender: Any) {
//
//     //   let settingView = UIView.load(nibName: "SettingView") as! SettingView
//
//      //  settingView.frame = self.view.frame
//
//      //  self.view.addSubview(settingView)
//
//
////
////        self.addChildViewController(accountViewController)
////
////        accountViewController.view.frame = self.view.frame
////        self.view.addSubview(accountViewController.view)
////        accountViewController.didMove(toParentViewController: self)
//
////        accountViewController.providesPresentationContextTransitionStyle = true
////        accountViewController.definesPresentationContext = true
////        accountViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
////        accountViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//
//
////        popOverVC.delegate = parent as? MainPageViewController
//
////        self.present(accountViewController, animated: true, completion: nil)
//
////        let firebaseAuth = Auth.auth()
////
////        do {
////            try firebaseAuth.signOut()
////
////        } catch let signOutError as NSError {
////
////            self.showAlert(title: "Oops!", message: "\(signOutError)")
////
////            print ("Error signing out: %@", signOutError)
////        }
////
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//
//        let accountViewController = storyboard.instantiateViewController(withIdentifier: "accountViewController") as! AccountViewController
//
//        let navigationController = UINavigationController(rootViewController: accountViewController)
////
//         self.present(navigationController, animated: true, completion: nil)
////        AppDelegate.shared.window?.updateRoot(
////            to: loginViewController,
////            animation: crossDissolve,
////            completion: nil
////        )
//
//    }
    
    func setupNavigationBar() {
        
        self.navigationItem.title = "Statistics"
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "menu-2"), for: .normal)
//        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(pushSettingpage), for: .touchUpInside)
        let settingButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = settingButton
        self.navigationItem.backBarButtonItem?.title = ""
//        let barButton = UIBarButtonItem(image: UIImage(named: "menu-2"), style: .plain, target: self, action: #selector(pushSettingpage))
//        barButton.image?.withRenderingMode(.alwaysOriginal)
//        self.navigationItem.rightBarButtonItem = barButton
        
    }
    
    @objc func pushSettingpage() {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let accountViewController = storyboard.instantiateViewController(withIdentifier: "accountViewController") as! AccountViewController
        
        self.navigationController?.pushViewController(accountViewController, animated: true)
        
    }
    
    func catchMainPage() {
        
        if let mainPageVC = self.tabBarController?.viewControllers?[0] as? MainPageViewController {
            
            self.visitedCountries = mainPageVC.visitedCountries
            
            self.classified()
            
            self.collectionView.reloadData()
        }
    }
    
    deinit {
        print("achievement controller@@@@")
    }
    
}

//extension AchievementViewController: DataModelDelegate {
//
//    func didReciveCountryData(_ provider: DataModel, visitedCountries: [Country]) {
//
//        self.visitedCountries = visitedCountries
//
////        setupNavigationTitle()
//
//        self.classified()
//
//        self.collectionView.reloadData()
//    }
//}

