//
//  scrambleGenerator.swift
//  iCube2
//
//  Created by JACOB Rasmussen on 7/7/16.
//  Copyright © 2016 Dangle. All rights reserved.
//
import Foundation

class scrambleGenerator {
    
    var sides: Int
    var str = ""
    var len = 0
    var rand = 0
    var opposite = ""
    
    //initializer that has the number of sides passed in assigns a len to each scramble depending on the cube size
    init(num: Int) {
        sides = num
        if(sides == 2){
            len = 20
        }
        else if(sides == 3){
            len = 25
        }
        else if (sides == 4){
            len = 30
        }
        else {
            len = 40
        }

    }
    //fasldkjf
    //function to pass back a string of moves for a scramble
    func generate() -> [String?] {
        var scramble = [String?](count:len, repeatedValue: nil)
        var last: String?
        //loops through the array and adds a turn to the scramble
            for index in 0...(len-1) {
                if(index > 0){
                    last = scramble[index - 1]
                }
                repeat{
                rand = randomInt(1, max: 60)
                if(rand < 10){
                    str = "F"
                    opposite = "B"
                }
                else if (rand < 20){
                    str = "B"
                    opposite = "F"
                }
                else if (rand < 30){
                    str = "R"
                    opposite = "L"
                }
                else if (rand < 40){
                    str = "L"
                    opposite = "R"
                }
                else if(rand < 50){
                    str = "U"
                    opposite = "D"
                }
                else{
                    str = "D"
                    opposite = "U"
                }
                } while(index > 0 && (last![0] == str  || last![0] == opposite))
                if((sides == 4 || sides == 5) && rand % 4 == 1){
                    str = "\(str)w"
                }
                if(sides == 6 || sides == 7){
                    if(rand % 3 == 2){
                    str = "2\(str)"
                    }
                    if (rand % 3 == 1){
                        str = "3\(str)"
                    }
                }
            if(rand % 3 == 0){
                str = "\(str)2"
            }
            if(rand % 4 == 0 && index >= 1 && last!.rangeOfString("'") == nil && str.rangeOfString("2") == nil){
                str = "\(str)'"
            }
        str = "\(str) "
        scramble[index] = str
        }
    return scramble
    }
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}
extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
}