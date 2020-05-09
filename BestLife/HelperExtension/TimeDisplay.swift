//
//  Double.swift
//  BestLife
//
//  Created by Mike Griffin on 4/10/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import UIKit

extension Double {
    func timeCounterDisplay() -> String {
        if(self < 60) {
            return String(format: "%d", Int(self)) + "s"
        }
        else {
            let hours = String(format:"%d", Int(self) / 3600)
            var minutesVal = 0
            var minuteFormat = ""
            if self >= 3600 {
                minutesVal = (Int(self) % 3600) / 60
                minuteFormat = "%02d"
            }
            else {
                minutesVal = Int(self) / 60
                minuteFormat = "%d"
            }
            let minutes = String(format: minuteFormat, minutesVal)
            let seconds = String(format: "%02d", Int(self) % 60)
            let displayString = (self > 3600) ? hours + ":" + minutes + ":" + seconds : minutes + ":" + seconds
            return displayString
        }
    }
}
