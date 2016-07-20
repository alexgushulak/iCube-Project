//
//  globalVars.swift
//  iCube2
//
//  Created by JACOB Rasmussen on 7/12/16.
//  Copyright © 2016 Dangle. All rights reserved.
//

import Foundation

struct global{
    static var inspectionTime = true
    static var freezeTime = true
    static var solves2: [Time] = []
    static var solves3: [Time] = []
    static var solves4: [Time] = []
    static var solves5: [Time] = []
    static var solves6: [Time] = []
    static var solves7: [Time] = []
}

func average(times: [Time])-> Time {
    var secondsTotal = 0.0
    var minutesTotal = 0
    for index in 0...(times.capacity-1){
        secondsTotal += times[index].getSec()
        minutesTotal += times[index].getMins()
    }
    let minutesAve = (Double)(minutesTotal) / (Double)(times.capacity)
    var secondsAve = secondsTotal / (Double)(times.capacity)
    let minutesRemainder = minutesAve % 1
    secondsAve += (minutesRemainder * 60)
    return Time(minutes: Int(minutesAve), sec: secondsAve)
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
}