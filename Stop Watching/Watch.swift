//
//  Watch.swift
//  Stop Watching
//
//  Created by Abdullah on 19/04/15.
//  Copyright (c) 2015 motjuste. All rights reserved.
//

import Foundation

class Watch {
    var fractions: Int = 0
    var seconds: Int = 0
    var minutes: Int = 0
    
    let incrementMod100 = makeModuloIncrementor(100)
    let incrementMod60 = makeModuloIncrementor(60)
    
    
    var watchString: String {
        get {
            let fractionsString = fractions > 9 ? "\(fractions)" : "0\(fractions)"
            let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
            let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
            
            return "\(minutesString):\(secondsString),\(fractionsString)"
        }
    }
    
    func incrementWatch() -> (Bool) {
        var overshot: Bool = false
        
        if incrementMod100(value: &fractions) {
            if incrementMod60(value: &seconds) {
                overshot = incrementMod100(value: &minutes)
            }
        }
        return overshot
    }
    
    func resetWatch() {
        (fractions, seconds, minutes) = (0, 0, 0)
    }
}

func makeModuloIncrementor (modulo: Int) -> (inout value: Int) -> (Bool) {
    func moduloIncrementor (inout value: Int) -> (Bool) {
        value++
        if value == modulo {
            value = 0
            return true
        } else {
            return false
        }
    }
    return moduloIncrementor
}