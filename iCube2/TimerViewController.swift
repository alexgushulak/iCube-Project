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
      
    @IBOutlet weak var millisecondDisplay: UILabel!
   
    @IBOutlet weak var periodDisplay: UILabel!
    
    
    @IBOutlet weak var secondDisplay: UILabel!
    
    @IBOutlet weak var decasecondDisplay: UILabel!
    
    @IBOutlet weak var minutesDisplay: UILabel!
    
    @IBAction func toggleTimer(sender: AnyObject) {
        if(!isRunning){
            // I got 3 decimal places somehow pls don't fuck with this if running on the simulator the time appears to be off for some damn reason but it works if run on an actual iPhone
           if(secondDisplay.textColor == UIColor.greenColor()){
                timer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
            //starts timer and chagnes color to white
                secondDisplay.textColor = UIColor.whiteColor()
                millisecondDisplay.textColor = UIColor.whiteColor()
                periodDisplay.textColor = UIColor.whiteColor()
                minutesDisplay.textColor = UIColor.whiteColor()
                decasecondDisplay.textColor = UIColor.whiteColor()
                isRunning = true
                letGo = true
            }
            //changes red back to white if the timer doesnt start and resets isRunning letGo and countDownTimer
            else if(secondDisplay.textColor == UIColor.redColor()){
                secondDisplay.textColor = UIColor.whiteColor()
                millisecondDisplay.textColor = UIColor.whiteColor()
                periodDisplay.textColor = UIColor.whiteColor()
                minutesDisplay.textColor = UIColor.whiteColor()
                decasecondDisplay.textColor = UIColor.whiteColor()
                isRunning = false
                countDownTimer.invalidate()
                letGo = false
            }
            
        }
        else{
            //invalidates timers and resets variables
            timer.invalidate()
            countDownTimer.invalidate()
            decaseconds = 0
            minutes = 0
            seconds = 0
            milliseconds = 0
            isRunning = false
            letGo = false
        }
    }
    //starts countdown when you first touch the timer sets color to red and starts the timer to change to green
    @IBAction func initializeTimer(sender: AnyObject) {
        if(!isRunning){
            secondDisplay.textColor = UIColor.redColor()
            millisecondDisplay.textColor = UIColor.redColor()
            periodDisplay.textColor = UIColor.redColor()
            minutesDisplay.textColor = UIColor.redColor()
             decasecondDisplay.textColor = UIColor.redColor()
            countDownTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(changeToGreen), userInfo: nil, repeats: false)
        }
    }
    //changes the color to green after .5 seconds
    func changeToGreen(){
        if(!isRunning && !letGo){
            secondDisplay.textColor = UIColor.greenColor()
            millisecondDisplay.textColor = UIColor.greenColor()
            periodDisplay.textColor = UIColor.greenColor()
            minutesDisplay.textColor = UIColor.greenColor()
            decasecondDisplay.textColor = UIColor.greenColor()
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Load View"){
            resetTimer()
        }
    }
    //resets the entier timer to it's initial state
    func resetTimer(){
        isRunning = false
        milliseconds = 0
        seconds = 0
        decaseconds = 0
        minutes = 0
        timer.invalidate()
        countDownTimer.invalidate()
        letGo = false
        
        secondDisplay.textColor = UIColor.whiteColor()
        millisecondDisplay.textColor = UIColor.whiteColor()
        periodDisplay.textColor = UIColor.whiteColor()
        minutesDisplay.textColor = UIColor.whiteColor()
        decasecondDisplay.textColor = UIColor.whiteColor()

          }
    //doesn't work if the user changes pages should invalidate timer if the user leaves the page
    //function executed every given time interval by the timer
    func runTimer(){
        //updating each variable for the amount of time that has passed
        if(secondDisplay.textColor != UIColor.redColor()){
            milliseconds += 1
            if(milliseconds == 1000){
                seconds += 1
                milliseconds = 0
            }
            if(seconds == 10){
                decaseconds += 1
                seconds = 0
            }
            if(decaseconds == 6){
                minutes += 1
                decaseconds = 0
            }
            //updating the labels with the appropriate numbers
            millisecondDisplay.text = "\(milliseconds)"
            secondDisplay.text = "\(seconds)"
            if (minutes != 0){
                decasecondDisplay.text = "\(decaseconds)"
                minutesDisplay.text = "\(minutes):"
            }
            else {
                minutesDisplay.text = ""
                if(decaseconds == 0){
                    decasecondDisplay.text = ""
                }
                else {
                    decasecondDisplay.text = "\(decaseconds)"
                }
            }
        }
    }
    //declaration of all variables
    var isRunning = false
    var milliseconds = 0
    var seconds = 0
    var decaseconds = 0
    var minutes = 0
    var timer = NSTimer()
    var countDownTimer = NSTimer()
    var letGo = false
    var generator3 = scrambleGenereator(num: 3)
}
