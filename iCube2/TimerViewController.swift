//
//  TimerViewController.swift
//  iCube2
//
//  Created by Alex on 7/6/16.
//  Copyright © 2016 Dangle. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
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
        
        // Adds a beautiful rounded corner to "dat" viewPicker
        cubePicker.layer.cornerRadius = 15.0
        cubePicker.hidden = true
        
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Makes the Status Bar White
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // View Picker for the Cube Picker
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
   
    @IBAction func OnOffButton(sender: AnyObject) {
        if cubePicker.hidden == true {
            cubePicker.hidden = false
        }
        else {
            cubePicker.hidden = true
        }
        
    }
    
    // Changes the Title to the Delected Row
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.title = cubeNames[row]
        
    }
    
    
    
    
    
    
    
    
      
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var scrambleLabel: UILabel!
   
    
    //declaration of variables
    private var displayLink: CADisplayLink?
    private var freezeTimer = NSTimer()
    private var inspectionTimer = NSTimer()
    private var minutes = 0.0
    private var seconds = "0.0"
    private var cubeSize = 3
    private var generator = scrambleGenerator(num: 3)
    private var countDownTime = 15
    private var isCountingDown = false
    
    //executed when the freeze timer ends
    func changeColor(){
        timerLabel.textColor = UIColor.greenColor()
    }
    //new timer stuff that I don't understand
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
    //supposed to update the label with the elapsed time but never does the minute stuff
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
            lastTime = endTime - startTime
            state = .Stopped
            displayLink?.paused = true
            scrambleLabel.text = toString(generator.generate())
            [scrambleLabel .sizeToFit()]
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
        if(elapsedTime == 60.00){
            minutes += 1
        }
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
            //maybe insert a ding or something here to signify the time starting
            countDownTime = 15
            isCountingDown = false

        }
    }
}