//
//  TimeInterval+Utils.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import Foundation



extension TimeInterval {
    var time: String {
        return String(format:"%02d:%02d", Int(self/60), Int(ceil(self.truncatingRemainder(dividingBy: 60))) )
    }
    
    var focusTime: String {
        let hours = Int(self / 3600)
        let minutes = Int((self.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(self.truncatingRemainder(dividingBy: 60))
        
        if hour == 0{
            return time
        }
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
 