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
}
 
