//
//  TimerViewController.swift
//  iCube2
//
//  Created by Alex on 7/6/16.
//  Copyright © 2016 Dangle. All rights reserved.
//

import UIKit
import AVFoundation


class TimerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        // sets up the view and puts out the first scramble
        timerLabel.textColor = UIColor.whiteColor()
        state = .Pending
        generator = scrambleGenerator(num: 3)
        scrambleLabel.textColor = UIColor.whiteColor()
        scrambleLabel.numberOfLines = 0
        scrambleLabel.text = toString(generator.generate())
        [scrambleLabel .sizeToFit()]
        self.tabBarController?.selectedIndex = 1
        //sets up the audio player with the chime sound
        do{
            try audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("chime", ofType: "mp3")!) )
        } catch {
            NSLog("Error: There's an error with the audio file chime.mp3")
        }
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
      
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var scrambleLabel: UILabel!
   
    
    //declaration of variables
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
    
    
    //executed when the freeze timer ends
    func changeColor(){
        timerLabel.textColor = UIColor.greenColor()
    }
    
    //new timer stuff that I kinda understand
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
            case .Pending: return UIColor.redColor()
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
            updateLabel()
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
                    timerLabel.textColor = UIColor.greenColor()
            }
            if(timerLabel.textColor == UIColor.whiteColor()){
                timerLabel.textColor = UIColor.redColor()
                if(global.freezeTime){
                    freezeTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(changeColor), userInfo: nil, repeats: false)
                }
                else{
                    timerLabel.textColor = UIColor.greenColor()
                }
            }
        case .Running:
            endTime = CFAbsoluteTimeGetCurrent()
            state = .Stopped
            displayLink?.paused = true
            scrambleLabel.text = toString(generator.generate())
            [scrambleLabel .sizeToFit()]
            minutes = 0
            minuteTimer.invalidate()
            lastTime = Time(minutes: minutes, sec: (Double)(elapsedTime))
            global.solves3.append(lastTime)
            timerLabel.text = lastTime.toString()
            StatisticsViewController().updateAverage()
        }
    }
    
    // what happens when you pick your finger up depending on the state of the timer
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if timerLabel.textColor == UIColor.greenColor() {
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
                    audioPlayer.play()
                }
            }
            else{
                startTime = CFAbsoluteTimeGetCurrent()
                displayLink?.paused = false
                state = .Running
                timerLabel.textColor = UIColor.whiteColor()
                minuteTimer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(updateMinutes), userInfo: nil, repeats: true)
                audioPlayer.play()
            }
        }
        else if timerLabel.textColor == UIColor.redColor(){
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
            audioPlayer.play()
            countDownTime = 15
            isCountingDown = false
        }
    }
}