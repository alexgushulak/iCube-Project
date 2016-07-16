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
}