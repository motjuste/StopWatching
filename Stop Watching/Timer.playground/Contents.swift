import Foundation

class Watch {
    var fractions: Int = 0
    var seconds: Int = 0
    var minutes: Int = 0
    
    let incrementMod100 = makeModuloIncrementor(100)
    let incrementMod60 = makeModuloIncrementor(60)
    
    
    var timerString: String {
        get {
            let fractionsString = fractions > 9 ? "\(fractions)" : "0\(fractions)"
            let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
            let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
            
            return "\(minutesString):\(minutesString),\(fractionsString)"
        }
    }
    
    func incrementWatch() {
        if incrementMod100(value: &fractions) {
            if incrementMod60(value: &seconds) {
                if incrementMod100(value: &minutes) {
                    // pass
                }
            }
        }
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