//
//  AchievementViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/17.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit

class AchievementViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, DataModelDelegate {
    
    func didReciveCountryData(visitedCountries: [Country]) {

        self.visitedCountries = visitedCountries

        self.classified()
  
        self.collectionView.reloadData()
    }
    
    private let dataModel = DataModel()
    var visitedCountries = [Country]()
    let continents = ["Europe", "Asia", "Africa", "North America", "South America", "Oceania"]
    var counters = ["Europe": 0, "Asia": 0, "Africa": 0, "North America": 0, "South America": 0, "Oceania": 0]

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataModel.delegate = self
        setupCollectionViewCells()
//        classified()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        dataModel.requestData()
        
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
            cell.continentImageView.image = UIImage(named: continents[indexPath.row])
        
            let countryCounts = continentCountryCount()
        
            let key = continents[indexPath.row]
        
            if let progress = counters[key] {

            cell.progressLabel.text = "\(progress)/\(countryCounts[indexPath.row])"
            }
        
            return cell
        
    }
    
    func setupCollectionViewCells() {
        
        let screenWidth = UIScreen.main.bounds.width - 20
        let screenHeight = UIScreen.main.bounds.height
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 10)
        
        let padding: CGFloat = 5
        let itemWidth = screenWidth/2 - padding
        let itemHeight = screenHeight/3 - padding
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView.collectionViewLayout = layout
        
    }
    
    func classified() {
        
        counters = ["Europe": 0, "Asia": 0, "Africa": 0, "North America": 0, "South America": 0, "Oceania": 0]

        for visitedCountry in visitedCountries {
            
            let countryId = visitedCountry.id
            
            for (key, value) in countryIdClassifiedByContinents {
                
                for contry in value {
                    
                    if contry == countryId {
                        
                        guard var counter = counters[key] else { return }

                        counter += 1

                        counters[key] = counter
                    }
                }
            }
        }
    }
    
    func continentCountryCount() -> [Int] {
        
        var countryAmount: [Int] = []
        
        for contient in continents {
            
            if let value = countryIdClassifiedByContinents[contient] {
                countryAmount.append(value.count)
            }
        }
        
        return countryAmount
    }
    
}
