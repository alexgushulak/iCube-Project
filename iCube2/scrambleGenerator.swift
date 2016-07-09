//
//  scrambleGenerator.swift
//  iCube2
//
//  Created by JACOB Rasmussen on 7/7/16.
//  Copyright © 2016 Dangle. All rights reserved.
//

import Foundation

class scrambleGenereator {
    
    var sides: Int
    
    //initializer that has the number of sides passed in
    init(num: Int) {
        sides = num
    }
    
    //function to pass back a string of moves for a scramble
    func generate() -> [String] {
        var scramble: [String]
        var str = ""
        var len = 0
        var rand = 0
        if(sides == 2){
            len = 20
        }
        else if(sides == 3 || sides == 4){
            len = 30
        }
        else {
            len = 40
        }
        
        for index in 0...(len-1) {
            rand = (Int)(arc4random_uniform(31))
            if(rand < 10){
                str = "F"
            }
            else if (rand < 20){
                str = "B"
            }
            else if (rand < 30){
                str = "R"
            }
            else if (rand < 40){
                str = "L"
            }
            else if(rand < 50){
                str = "U"
            }
            else{
                str = "D"
            }
            if(rand % 4 == 0 && (sides == 4 || sides == 5) && str.rangeOf("w") == nil){
                str = "\(str)w"

            }
            if(rand % 3 == 2 && (sides == 6 || sides == 7)){
                str = "2\(str)"
            }
            else if (rand % 3 == 1 && (sides == 6 || sides == 7)){
                str = "3\(str)"
            }
            if(rand % 3 == 0){
                str = "\(str)2"
            }
            if(rand % 4 == 0 && index >= 1 && last(scramble[index-1]) != "'" && last(scramble[index-1]) != "2"){
                str = "\(str)'"
            }
        scramble.append(str)
        }
    return scramble
    }
}