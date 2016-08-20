//
//  StatisticsViewController.swift
//  iCube2
//
//  Created by JACOB Rasmussen on 8/19/16.
//  Copyright © 2016 Dangle. All rights reserved.
//

import Foundation

import UIKit
class StatisticsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StatisticsViewController.refresh(_:)), name: "refresh", object: nil)
        updateAverage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    func refresh(notification: NSNotification) {
        updateAverage()
        let lastTime = global.currentSolves.last!
        var best = global.currentBest.compare(lastTime)
        if (bestTime.text == "0.00"){
            best = lastTime
        }
        if(lastTime.getMins() == best.getMins() && lastTime.getSec() == best.getSec()){
            global.currentBest = lastTime
            if(global.currentCube == "2x2"){
                global.best2 = lastTime
            }
            if(global.currentCube == "3x3"){
                global.best3 = lastTime
            }
            if(global.currentCube == "4x4"){
                global.best4 = lastTime
            }
            if(global.currentCube == "5x5"){
                global.best5 = lastTime
            }
            if(global.currentCube == "6x6"){
                global.best6 = lastTime
            }
            if(global.currentCube == "7x7"){
                global.best7 = lastTime
            }

        }
        bestTime.text = best.toString()
    }

    @IBOutlet weak var allTimeAverageTime: UILabel!

    @IBOutlet weak var bestTime: UILabel!

    func updateAverage() {
        let aveTime = average(global.currentSolves).toString()
        allTimeAverageTime.text = "\(aveTime)"
    }
}
