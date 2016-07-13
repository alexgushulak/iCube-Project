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
        timerLabel.textColor = UIColor.whiteColor()
        state = .Pending
        generator = scrambleGenerator(num: 3)
        scrambleLabel.textColor = UIColor.whiteColor()
        scrambleLabel.numberOfLines = 0
        scrambleLabel.text = toString(generator.generate())
        [scrambleLabel .sizeToFit()]
        self.tabBarController?.selectedIndex = 1
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
   
    
    //attempt for a new timer that fucking works now!!!
    private var displayLink: CADisplayLink?
    private var freezeTimer = NSTimer()
    private var inspectionTimer = NSTimer()
    private var minutes = 0.0
    private var seconds = "0.0"
    private var cubeSize = 3
    private var generator = scrambleGenerator(num: 3)
    private var countDownTime = 15
    private var isCountingDown = false
    
    func changeColor(){
        timerLabel.textColor = UIColor.greenColor()
    }
    private var startTime: CFAbsoluteTime = 0
    private var lastTime: CFAbsoluteTime = 0
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
        case .Stopped, .Pending: return lastTime
        case .Running: return CFAbsoluteTimeGetCurrent() - startTime
        }
    }
    private func updateLabel() {
        seconds = String(format: "%.02f", elapsedTime)
        if(minutes > 1){
            seconds = String(format: "%.02f", (60.0 * minutes - elapsedTime))
        }
        if(minutes == 0){
            timerLabel.text = "\(seconds)"
        }
        else {
            timerLabel.text = "\(minutes):\(seconds)"
        }

    }
    private var state = State.Stopped {
        didSet {
            updateLabel()
        }
    }
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
            lastTime = endTime - startTime
            state = .Stopped
            displayLink?.paused = true
            scrambleLabel.text = toString(generator.generate())
            [scrambleLabel .sizeToFit()]
        }
    }
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
                }
            }
            else{
                startTime = CFAbsoluteTimeGetCurrent()
                displayLink?.paused = false
                state = .Running
                timerLabel.textColor = UIColor.whiteColor()
            }
        }
        if timerLabel.textColor == UIColor.redColor(){
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
    private func createDisplayLinkIfNeeded() {
        guard self.displayLink == nil else { return }
        let displayLink = CADisplayLink(target: self, selector: #selector(TimerViewController.displayLinkDidFire(_:)))
        displayLink.paused = true
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        self.displayLink = displayLink
    }
    func displayLinkDidFire(_: CADisplayLink) {
        updateLabel()
        if(elapsedTime == 60.00){
            minutes += 1
        }
    }
    func toString(arrayOne: [String?])->String{
        let len = arrayOne.count
        var ret = ""
        for index in 0...(len-1){
            ret = "\(ret)\(arrayOne[index]!)"
        }
        return ret
    }
    func countDown(){
        countDownTime -= 1
        timerLabel.text = "\(countDownTime)"
        if(countDownTime == 0){
            startTime = CFAbsoluteTimeGetCurrent()
            displayLink?.paused = false
            state = .Running
            inspectionTimer.invalidate()
            //maybe insert a ding or something here to signify the time starting
            countDownTime = 15
            isCountingDown = false

        }
    }
}