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
    var continent = ""
//    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        refreshControl = UIRefreshControl()
//        tableView.addSubview(refreshControl)
//        refreshControl.tintColor = UIColor.clear
//        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
//        loadCustomRefreshContens()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        setupNavigationBar()
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        updateData()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
//        self.navigationController?.popViewController(animated: true)
    }
    
//    @objc func loadCustomRefreshContens(){
//
//        if let refreshView = UIView.load(nibName: "RefreshView") as? RefreshView {
//
//            refreshControl.addSubview(refreshView)
//            refreshView.frame = refreshControl.bounds
//
//            UIView.animate(withDuration: 2, animations: {
//                let circlePath = UIBezierPath(arcCenter: self.refreshControl.center, radius: 15, startAngle: 0, endAngle: .pi*2, clockwise: false)
//                let animation = CAKeyframeAnimation(keyPath: "position")
//                animation.duration = 1.5
//                animation.rotationMode = kCAAnimationRotateAuto
//                animation.repeatCount = MAXFLOAT
//                animation.path = circlePath.cgPath
//                refreshView.paperPlaneImageView.layer.add(animation, forKey: "wave")
//            }, completion: { (true) in
//                self.refreshControl.endRefreshing()
//            })
//        }
//
//        updateData()
//
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if refreshControl.isRefreshing {
//            loadCustomRefreshContens()
//        }


//    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func setupNavigationBar() {
        
        self.navigationItem.title = NSLocalizedString("Collection", comment: "")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.black
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var numberOfSections = 0
        
        if visitedCountries.count > 0 {
            
            tableView.backgroundView = nil
            
            numberOfSections = 1
            
        } else {

            showNoDataInfo()
        }
        
        return numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return visitedCountries.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "continentDetailTableViewCell", for: indexPath) as! ContinentDetailTableViewCell

//        cell.isUserInteractionEnabled = false
        
        print("indexPath:\(indexPath)")
        
        guard let flag = Flag(countryCode: visitedCountries[indexPath.row].id) else { return cell }

        let styledImage = flag.image(style: .circle)

        cell.countryNameLabel.text = visitedCountries[indexPath.row].name
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
    
    func updateData() {

        if let achievementViewController = self.navigationController?.childViewControllers[0] as? AchievementViewController {
            achievementViewController.catchMainPage()
            guard let newData = achievementViewController.countries[self.continent] else { print("update fail"); return}
            self.visitedCountries = newData

            self.tableView.reloadData()
//            refreshControl.endRefreshing()
        }

    }
    
    func showNoDataInfo() {
        
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        let font = UIFont(name: "Avenir-Medium", size: 18)
        noDataLabel.font = font
        noDataLabel.text = "Next trip to \(continent)?"
        noDataLabel.textColor = UIColor.black
        noDataLabel.textAlignment = .center

        let waterView = WaveView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 150), color: UIColor.white)
        
        waterView.backgroundColor = UIColor.clear
        
        waterView.addOverView(noDataLabel)
        
        tableView.backgroundView = waterView
        
        waterView.start()
    }
    
    deinit {
        print("ContinentDetailViewController@@@@@")
    }

}
