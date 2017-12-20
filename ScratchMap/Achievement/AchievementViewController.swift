//
//  AchievementViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/17.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit

class AchievementViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var beenToCountries = [Country]()
    let continents = ["Europe", "Asia", "Africa", "North America", "South America", "Oceania"]
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let europeanCountries = [
        "AL": "Albania",
        "AD": "Andorra"
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(beenToCountries)
        setupCollectionViewCells()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
     return 6

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "achievementCollectionViewCell", for: indexPath) as! AchievementCollectionViewCell
            
            cell.continentLabel.text = continents[indexPath.row]
            
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
        
        print(layout.itemSize)
        
        collectionView.collectionViewLayout = layout
        
    }

    
    

}
