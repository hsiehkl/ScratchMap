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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visitedCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "continentDetailTableViewCell", for: indexPath) as! ContinentDetailTableViewCell
        
        guard let flag = Flag(countryCode: visitedCountries[indexPath.row].id) else { return cell }
        
        let styledImage = flag.image(style: .circle)
        
        cell.countryNameLabel.text = visitedCountries[indexPath.row].name
        cell.countryFlagImage.image = styledImage
        
        return cell
    }


}
