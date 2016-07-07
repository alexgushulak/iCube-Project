//
//  TimerViewController.swift
//  iCube2
//
//  Created by Alex on 7/6/16.
//  Copyright © 2016 Dangle. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBOutlet weak var displayTimeLabel: UILabel!
    
    @IBAction func start(sender: AnyObject) {
        
    }
    
    @IBAction func stop(sender: AnyObject) {
    }
    
    var startTime = NSTimeInterval()
    
    func updateTime() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time
        
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        // calculate the minutes in elapsed time
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        // calculate the seconds in elapsed time
        
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= NSTimeInterval(seconds)
        
        //  find out the fraction of milliseconds to be displayed.
        
        let fraction = UInt8(elapsedTime * 100)
        
        // add the leading zero for minutes, seconds, and milli
        
        let strMinutes = String(format: "d%02d", minutes)
        let strSeconds = String(format: "d%02d", seconds)
        let strFraction = String(format: "d%02d", fraction)
        
        // concatenate minutes, seconds and milliseconds
        
        displayTimeLabel.text = "\(strMinutes):\(strSeconds):\(strFractions):\"
    }

    
    
}
