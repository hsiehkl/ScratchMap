//
//  AchievementViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/17.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import FirebaseAuth

class AchievementViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, DataModelDelegate {
    
    func didReciveCountryData(_ provider: DataModel, visitedCountries: [Country]) {

        self.visitedCountries = visitedCountries

        self.classified()
  
        self.collectionView.reloadData()
    }
    
    private let dataModel = DataModel()
    var visitedCountries = [Country]()
    let continents = ["Europe", "Asia", "Africa", "North America", "South America", "Oceania"]
    var countries: [String: [Country]] = ["Europe": [], "Asia": [], "Africa": [], "North America": [], "South America": [], "Oceania": []]

    @IBOutlet weak var worldAchievementLabel: UILabel!
    @IBOutlet weak var logoutButtonOutlet: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Achievement_______Page")
        
        dataModel.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        dataModel.requestData()
        
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
            
//            print("ScreenWidth1~~~ \(screenWidth)")
//            print("ScreenHeight1~~~ \(screenHeight)")
            
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
            

            
            print("here!\(itemWidth),\(itemHeight)")
            
            
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
            
            cell.continentLabel.text = continents[indexPath.row]
            cell.imageView.image = UIImage(named: "\(continents[indexPath.row])-1")
        
            let continentCountryAmount = continentCountryCount()
        
            let key = continents[indexPath.row]
        
            if let progress = countries[key]?.count {

            cell.progressLabel.text = "\(progress)/\(continentCountryAmount[indexPath.row])"
            }
        
            return cell
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
        
        let totalCountryAmount = continentCountryAmount.reduce(0) { $0 + $1 }
        self.worldAchievementLabel.text = "\(visitedCountries.count)/\(totalCountryAmount)"
        
        return continentCountryAmount
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            
        } catch let signOutError as NSError {
            
            self.showAlert(title: "Oops!", message: "\(signOutError)")
            
            print ("Error signing out: %@", signOutError)
        }
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController

        AppDelegate.shared.window?.updateRoot(
            to: loginViewController,
            animation: crossDissolve,
            completion: nil
        )
        
    }
    
    deinit {
        print("achievement controller@@@@")
    }
    
}
