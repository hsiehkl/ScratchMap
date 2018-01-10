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
        self.navigationItem.title = NSLocalizedString("Collection", comment: "")

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
//        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visitedCountries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "continentDetailTableViewCell", for: indexPath) as! ContinentDetailTableViewCell

//        cell.isUserInteractionEnabled = false
        
        guard let flag = Flag(countryCode: visitedCountries[indexPath.row].id) else { return cell }

        let styledImage = flag.image(style: .circle)

        cell.countryNameLabel.text = visitedCountries[indexPath.row].name
        cell.countryFlagImage.image = styledImage

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newsFeedViewController = storyboard.instantiateViewController(withIdentifier: "newsFeedViewController") as! NewsFeedViewController
        
        self.navigationController?.pushViewController(newsFeedViewController, animated: true)

        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    deinit {
        print("ContinentDetailViewController@@@@@")
    }

}
