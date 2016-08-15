//
//  globalVars.swift
//  iCube2
//
//  Created by JACOB Rasmussen on 7/12/16.
//  Copyright © 2016 Dangle. All rights reserved.
//

import Foundation

struct global{
    static var lastSolve = Time(minutes: 0, sec: 0.0)
    static var currentCube = "3x3"
    static var inspectionTime = false
    static var freezeTime = true
    static var blackScreen = false
    static var solves2: [Time] = []
    static var solves3: [Time] = []
    static var solves4: [Time] = []
    static var solves5: [Time] = []
    static var solves6: [Time] = []
    static var solves7: [Time] = []
    static var currentSolves: [Time] = []
}

func average(times: [Time])-> Time {
    var secondsTotal = 0.0
    var minutesTotal = 0
    if(times.count == 0){
        return Time(minutes: 0, sec: 0.0)
    }
    if(times.count == 1){
        return times[0]
    }
    for index in 0...(times.count-1){
        secondsTotal += times[index].getSec()
        minutesTotal += times[index].getMins()
    }
    let minutesAve = (Double)(minutesTotal) / (Double)(times.count)
    var secondsAve = secondsTotal / (Double)(times.count)
    let minutesRemainder = minutesAve % 1
    secondsAve += (minutesRemainder * 60)
    return Time(minutes: Int(minutesAve), sec: secondsAve)
}

func addTime(time: Time){
    global.currentSolves.append(time)
    if(global.currentCube == "2x2"){
        global.solves2.append(time)
    }
    if(global.currentCube == "3x3"){
        global.solves3.append(time)
    }
    if(global.currentCube == "4x4"){
        global.solves4.append(time)
    }
    if(global.currentCube == "5x5"){
        global.solves5.append(time)
    }
    if(global.currentCube == "6x6"){
        global.solves6.append(time)
    }
    if(global.currentCube == "7x7"){
        global.solves7.append(time)
    }
}

class Time {
    private var mins: Int
    private var seconds: Double
    
    init(minutes: Int, sec: Double) {
        mins = minutes
        seconds = sec
    }
    func toString()->String{
        let sec = String(format: "%0.02f", seconds)
        if(mins == 0){
            return "\(sec)"
        }
        else {
            return "\(mins):\(sec)"
        }
    }
    func getMins()->Int{
        return mins
    }
    func getSec()->Double{
        return seconds
    }
    func toSec()->Double {
        var secs = seconds
        secs += Double(mins) * 60.0
        return secs
    }
    
}