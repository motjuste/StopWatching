//
//  Watch.swift
//  Stop Watching
//
//  Created by Abdullah on 19/04/15.
//  Copyright (c) 2015 motjuste. All rights reserved.
//

import Foundation

struct WatchValues {
    var fractions: Int
    var seconds: Int
    var minutes: Int
}

class Watch {
    var values: WatchValues
    
    let incrementMod100 = makeModuloIncrementor(100)
    let incrementMod60 = makeModuloIncrementor(60)
    
    var watchString: String {
        get {
            let fractionsString = values.fractions > 9 ? "\(values.fractions)" : "0\(values.fractions)"
            let secondsString = values.seconds > 9 ? "\(values.seconds)" : "0\(values.seconds)"
            let minutesString = values.minutes > 9 ? "\(values.minutes)" : "0\(values.minutes)"
            
            return "\(minutesString):\(secondsString),\(fractionsString)"
        }
    }
    
    init (fractions: Int = 0, seconds: Int = 0, minutes: Int = 0) {
        values = WatchValues(fractions: fractions, seconds: seconds, minutes: minutes)
    }
    
    func incrementWatch() -> (Bool) {
        var overshot: Bool = false
        
        if incrementMod100(value: &values.fractions) {
            if incrementMod60(value: &values.seconds) {
                overshot = incrementMod100(value: &values.minutes)
            }
        }
        return overshot
    }
    
    func resetWatch() {
        values = WatchValues(fractions: 0, seconds: 0, minutes: 0)
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