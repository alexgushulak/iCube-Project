//
//  StatisticsViewController.swift
//  iCube2
//
//  Created by Alex on 7/6/16.
//  Copyright © 2016 Dangle. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StatisticsViewController.refreshAve(_:)), name: "refresh", object: nil)
       updateAverage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    func refreshAve(notification: NSNotification) {
        updateAverage()
    }
    
    @IBOutlet weak var averageTime: UILabel!
    
    
    func updateAverage() {
        let aveTime = average(global.currentSolves).toString()
        averageTime.text = "\(aveTime)"
    }

}
