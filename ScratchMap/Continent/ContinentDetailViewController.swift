//
//  ContinentDetailViewController.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/5.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//

import UIKit
import FlagKit

class ContinentDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var visitedCountries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        setupNavigationBar()
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
//        self.navigationController?.popViewController(animated: true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func setupNavigationBar() {
        
        self.navigationItem.title = NSLocalizedString("Collection", comment: "")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.black
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if visitedCountries.count < 1 {
            return 1
        } else {
            return visitedCountries.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "continentDetailTableViewCell", for: indexPath) as! ContinentDetailTableViewCell

//        cell.isUserInteractionEnabled = false
        
        print("indexPath:\(indexPath)")
        
        guard let flag = Flag(countryCode: visitedCountries[indexPath.row].id) else { return cell }

        let styledImage = flag.image(style: .circle)
        
        let abbreviatedName = Abbreviation.abbreviation(countryName: visitedCountries[indexPath.row].name)

        cell.countryNameLabel.text = abbreviatedName
        cell.countryFlagImage.image = styledImage

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newsFeedViewController = storyboard.instantiateViewController(withIdentifier: "newsFeedViewController") as! NewsFeedViewController

        newsFeedViewController.navigationTitle = visitedCountries[indexPath.row].name
        
        self.navigationController?.pushViewController(newsFeedViewController, animated: true)

        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    deinit {
        print("ContinentDetailViewController@@@@@")
    }

}
