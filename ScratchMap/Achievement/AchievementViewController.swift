//
//  AchievementViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/17.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import FirebaseAuth

class AchievementViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var visitedCountries = [Country]()
    
    let continentsForLabel = [NSLocalizedString("Europe", comment: ""), NSLocalizedString("Asia", comment: ""), NSLocalizedString("Africa", comment: ""), NSLocalizedString("North America", comment: ""), NSLocalizedString("South America", comment: ""), NSLocalizedString("Oceania", comment: "")]
    
    let continents = ["Europe", "Asia", "Africa", "North America", "South America", "Oceania"]
    
    var countries: [String: [Country]] = ["Europe": [], "Asia": [], "Africa": [], "North America": [], "South America": [], "Oceania": []]
    
//    let progressBar = ProgressBarView()

    @IBOutlet weak var worldAchievementLabel: UILabel!
    @IBOutlet weak var logoutButtonOutlet: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.black

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

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
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 10

            collectionView.collectionViewLayout = layout
        }

        layout.invalidateLayout()
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

            cell.continentLabel.text = "\(continentsForLabel[indexPath.row])"

            let progress = CGFloat(progressAmount)/CGFloat(continentCountryAmount[indexPath.row])

//            let fakeProgress = CGFloat(progressAmount)/CGFloat(continentCountryAmount[indexPath.row]) * 2

            cell.continentProgressBarView.progress = progress

            let percentage = progress * 100
            cell.continentProgressAmountLabel.text = "\(progressAmount)/\(continentCountryAmount[indexPath.row])"
            cell.continentPercentageLabel.text = "\(String(format: "%.0f", percentage))%"

            }

            return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let continentDetailViewController = storyboard.instantiateViewController(withIdentifier: "continentDetailViewController") as! ContinentDetailViewController

        guard let visitedCountriesInContinent = countries[(continents[indexPath.row])] else { return }

        continentDetailViewController.visitedCountries = visitedCountriesInContinent
        continentDetailViewController.continent = (continents[indexPath.row])

        self.navigationController?.pushViewController(continentDetailViewController, animated: true)
        
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
            
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "worldHeader", for: indexPath) as! WorldCollectionReusableView

            let totalCountryAmount = continentCountryCount().reduce(0) { $0 + $1 }

            headerView.worldProgressLabel.text = "\(visitedCountries.count)/\(totalCountryAmount)"

            let progress = CGFloat(visitedCountries.count)/CGFloat(totalCountryAmount)
//            let fakeProgress = CGFloat(visitedCountries.count)/CGFloat(totalCountryAmount) * 2
            headerView.progressBarView.progress = progress
            let percentage = progress * 100
            print(" progreeeeeeee \(String(format: "%.2f", percentage))")
            headerView.worldPercentageLabel.text = "\(String(format: "%.0f", percentage))%"

            return headerView
            
        default:
            
            return WorldCollectionReusableView()
        }
    }

    func classified() {
        
        countries = ["Europe": [], "Asia": [], "Africa": [], "North America": [], "South America": [], "Oceania": []]
        
        for visitedCountry in visitedCountries {
            
            guard let continent = visitedCountry.continent else { continue }
            
            switch continent {
                
            case Continent.europe.rawValue:
                countries[Continent.europe.rawValue]?.append(visitedCountry)
            
            case Continent.asia.rawValue:
                countries[Continent.asia.rawValue]?.append(visitedCountry)
                
            case Continent.africa.rawValue:
                countries[Continent.africa.rawValue]?.append(visitedCountry)
                
            case Continent.northAmerica.rawValue:
                countries[Continent.northAmerica.rawValue]?.append(visitedCountry)
                
            case Continent.southAmerica.rawValue:
                countries[Continent.southAmerica.rawValue]?.append(visitedCountry)
                
            case Continent.oceania.rawValue:
                countries[Continent.oceania.rawValue]?.append(visitedCountry)
                
            case Continent.europeAndAsia.rawValue:
                countries[Continent.europe.rawValue]?.append(visitedCountry)
                countries[Continent.asia.rawValue]?.append(visitedCountry)
                
            default:
                continue
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

    func setupNavigationBar() {

        self.navigationItem.title = NSLocalizedString("Statistics", comment: "")

        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "menu-2"), for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(pushSettingpage), for: .touchUpInside)
        let settingButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = settingButton
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
        
        
        print("achieve! \(self.countries["Oceania"]?.last?.name)")
    }

    deinit {
        print("achievement controller@@@@")
    }

}
