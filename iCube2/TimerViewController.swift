//
//  TimerViewController.swift
//  iCube2
//
//  Created by Alex on 7/6/16.
//  Copyright © 2016 Dangle. All rights reserved.
//

import UIKit
import AVFoundation


class TimerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets up the view and puts out the first scramble
        timerLabel.textColor = UIColor.whiteColor()
        timerLabel.text = "Start"
        state = .Pending
        generator = scrambleGenerator(num: 3)
        scrambleLabel.textColor = UIColor.whiteColor()
        scrambleLabel.numberOfLines = 0
        scrambleLabel.text = toString(generator.generate())
        
        // Opens on center Index
        self.tabBarController?.selectedIndex = 1
        
        // Gesture Controller for the CubePicker
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        cubePicker.hidden = true
        self.timerLabel.alpha = 0
        self.scrambleLabel.alpha = 0
        
        // Animations
        UIView.animateWithDuration(0.4, delay: 0.2, options: [.CurveEaseIn, .CurveEaseOut], animations: {
            self.timerLabel.alpha = 1
            self.scrambleLabel.alpha = 1
            self.timerLabel.center.y += 10
            self.scrambleLabel.center.y += 10
        }, completion: nil)
        
        // Beautification
        cubePicker.layer.cornerRadius = 20
        self.cubePicker.alpha = 0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // CubePicker Creation
    let cubeNames = ["2x2", "3x3", "4x4", "5x5", "6x6", "7x7", "Megaminx", "Skewb", "Square-1", "Pyraminx"]
    
    @IBOutlet weak var cubePicker: UIPickerView!
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cubeNames.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cubeNames[row]
    }
   
    
    // Changes the Title to the Delected Row
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.title = cubeNames[row]
        if(self.title == "2x2"){
            generator = scrambleGenerator(num: 2)
            global.currentSolves = global.solves2
        }
        if(self.title == "3x3"){
            generator = scrambleGenerator(num: 3)
            global.currentSolves = global.solves3
        }
        if(self.title == "4x4"){
            generator = scrambleGenerator(num: 4)
            global.currentSolves = global.solves4
        }
        if(self.title == "5x5"){
            generator = scrambleGenerator(num: 5)
            global.currentSolves = global.solves5
        }
        if(self.title == "6x6"){
            generator = scrambleGenerator(num: 6)
            global.currentSolves = global.solves6
        }
        if(self.title == "7x7"){
            generator = scrambleGenerator(num: 7)
            global.currentSolves = global.solves7
        }
        scrambleLabel.text = toString(generator.generate())
        global.currentCube = self.title!
        NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil, userInfo: nil)
    }
    
    func doubleTapped() {
        if cubePicker.hidden == true {
            UIView.animateWithDuration(0.4, delay: 0.0, options: [.CurveEaseIn, .CurveEaseOut], animations: {
                self.cubePicker.hidden = false
                self.cubePicker.alpha = 1
                }, completion: nil)

        }
        else {
            cubePicker.hidden = true
            self.cubePicker.alpha = 0
            state = .Pending
            timerLabel.textColor = UIColor.whiteColor()
        }
        
    }
      
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var scrambleLabel: UILabel!
    
    // Declaration of variables
    private var displayLink: CADisplayLink?
    private var freezeTimer = NSTimer()
    private var inspectionTimer = NSTimer()
    private var minuteTimer = NSTimer()
    private var audioPlayer = AVAudioPlayer()
    private var minutes = 0
    private var seconds = "0.0"
    private var cubeSize = 3
    private var generator = scrambleGenerator(num: 3)
    private var countDownTime = 15
    private var isCountingDown = false
    
    
    // executed when the freeze timer ends
    func changeColor(){
        timerLabel.textColor = UIColor(red: 0.3765, green: 0.9686, blue: 0.4078, alpha: 1.0)
    }
    
    // TIMER SHIT
    private var startTime: CFAbsoluteTime = 0
    private var lastTime = Time(minutes: 0, sec: 0.00)
    private var endTime: CFAbsoluteTime = 0 {
        didSet {
            updateLabel()
        }
    }
    private enum State {
        case Stopped
        case Pending
        case Running
        
        var labelColor: UIColor {
            switch self {
            case .Pending: return UIColor(red: 0.9686, green: 0.2196, blue: 0.2196, alpha: 1.0)
            case .Stopped, .Running: return UIColor.whiteColor()
            }
        }
    }
    private var elapsedTime: NSTimeInterval {
        switch state {
        case .Stopped, .Pending: return endTime - startTime
        case .Running: return CFAbsoluteTimeGetCurrent() - startTime
        }
    }
    
    //supposed to update the label with the elapsed time but never does the minute stuff
    private func updateLabel() {
        switch state {
        case .Stopped, .Pending:
            timerLabel.text = lastTime.toString()
        case .Running:
            seconds = String(format: "%.02f", elapsedTime)
            if(minutes == 0){
                timerLabel.text = "\(seconds)"
            }
            else{
                seconds = String(format: "%0.02f", elapsedTime - 60.0 * (Double)(minutes))
                if(elapsedTime - 60.0 * (Double)(minutes) < 10){
                    timerLabel.text = "\(minutes):0\(seconds)"
                }
                else {
                    timerLabel.text = "\(minutes):\(seconds)"
                }
            }
        }
    }
    private var state = State.Stopped {
        didSet {
            
        }
    }
    
    //what happens for each time you touch down depending on the current state of the timer
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        createDisplayLinkIfNeeded()
        switch state {
        case .Stopped:
            state = .Pending
        case .Pending:
            if(isCountingDown){
                    timerLabel.textColor = UIColor(red: 0.3765, green: 0.9686, blue: 0.4078, alpha: 1.0)
            }
            if(timerLabel.textColor == UIColor.whiteColor()){
                timerLabel.textColor = UIColor(red: 0.9686, green: 0.2196, blue: 0.2196, alpha: 1.0)
                if(global.freezeTime){
                    freezeTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(changeColor), userInfo: nil, repeats: false)
                }
                else{
                    timerLabel.textColor = UIColor(red: 0.3765, green: 0.9686, blue: 0.4078, alpha: 1.0)
                }
            }
        case .Running:
            endTime = CFAbsoluteTimeGetCurrent()
            state = .Stopped
            displayLink?.paused = true
            scrambleLabel.text = toString(generator.generate())
            [scrambleLabel .sizeToFit()]
            minuteTimer.invalidate()
            lastTime = Time(minutes: minutes, sec: (Double)(elapsedTime) - ((Double)(minutes) * 60.0))
            global.lastSolve = lastTime
            addTime(lastTime)
            NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil, userInfo: nil)
             minutes = 0
        }
    }
    
    // what happens when you pick your finger up depending on the state of the timer
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if timerLabel.textColor == UIColor(red: 0.3765, green: 0.9686, blue: 0.4078, alpha: 1.0) {
            if(global.inspectionTime){
                if(!isCountingDown){
                    isCountingDown = true
                    inspectionTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:   #selector(countDown), userInfo: nil, repeats: true)
                    timerLabel.textColor = UIColor.whiteColor()
                    timerLabel.text = "\(countDownTime)"
                }
                else {
                    inspectionTimer.invalidate()
                    isCountingDown = false
                    startTime = CFAbsoluteTimeGetCurrent()
                    displayLink?.paused = false
                    state = .Running
                    timerLabel.textColor = UIColor.whiteColor()
                    countDownTime = 15
                    minuteTimer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(updateMinutes), userInfo: nil, repeats: true)
                }
            }
            else{
                startTime = CFAbsoluteTimeGetCurrent()
                displayLink?.paused = false
                state = .Running
                timerLabel.textColor = UIColor.whiteColor()
                minuteTimer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(updateMinutes), userInfo: nil, repeats: true)
            }
        }
        else if (timerLabel.textColor == UIColor(red: 0.9686, green: 0.2196, blue: 0.2196, alpha: 1.0)){
            state = .Stopped
            timerLabel.textColor = UIColor.whiteColor()
            freezeTimer.invalidate()
            startTime = CFAbsoluteTimeGetCurrent()
            endTime = CFAbsoluteTimeGetCurrent()

        }
        if(state == .Stopped){
            state = .Pending
        }
    }
    
    func updateMinutes(){
        minutes += 1
    
    }
    
    //shennanigans that I don't understand
    private func createDisplayLinkIfNeeded() {
        guard self.displayLink == nil else { return }
        let displayLink = CADisplayLink(target: self, selector: #selector(TimerViewController.displayLinkDidFire(_:)))
        displayLink.paused = true
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        self.displayLink = displayLink
    }
    
    func displayLinkDidFire(_: CADisplayLink) {
        updateLabel()
    }
    
    //puts an array of strings into one big string valuable for printing the scrambles
    func toString(arrayOne: [String?])->String{
        let len = arrayOne.count
        var ret = ""
        for index in 0...(len-1){
            ret = "\(ret)\(arrayOne[index]!)"
        }
        return ret
    }
    
    //fired once per second during the inspection time
    func countDown(){
        countDownTime -= 1
        timerLabel.text = "\(countDownTime)"
        if(countDownTime == 0){
            startTime = CFAbsoluteTimeGetCurrent()
            displayLink?.paused = false
            state = .Running
            inspectionTimer.invalidate()
            countDownTime = 15
            isCountingDown = false
        }
    }
}