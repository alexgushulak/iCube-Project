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
    private var countDownTimer = NSTimer()
    private var minutes = 0.0
    private var seconds = "0.0"
    private var cubeSize = 3
    private var generator = scrambleGenerator(num: 3)
    
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
            if(timerLabel.textColor == UIColor.whiteColor()){
            timerLabel.textColor = UIColor.redColor()
            countDownTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(changeColor), userInfo: nil, repeats: false)
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
            startTime = CFAbsoluteTimeGetCurrent()
            displayLink?.paused = false
            state = .Running
            timerLabel.textColor = UIColor.whiteColor()
        }
        if timerLabel.textColor == UIColor.redColor(){
            state = .Stopped
            timerLabel.textColor = UIColor.whiteColor()
            countDownTimer.invalidate()
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
}