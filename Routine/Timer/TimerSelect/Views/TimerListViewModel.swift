//
//  TimerListViewModel.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import Foundation
import UIKit.UIColor

struct TimerListViewModel: Hashable{
    let timerId: UUID
    let name: String
    let info: String
    let tint: UIColor?
    
    init(_ model: TimerListModel) {
        self.timerId = model.timerId
        self.name = model.name
        
        switch model.timerType {
        case .focus:
            self.info = "Focus"
        case .section:
            self.info = "Interval"
        }
        
        
        self.tint = UIColor(hex: model.tint)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(timerId)
        hasher.combine(name)
    }
    
    static func ==(lsh: TimerListViewModel, rhs: TimerListViewModel){
        lsh.timerId == rhs.timerId && lsh.name == rhs.name &&
        lsh.info == rhs.info && lsh.tint == rhs.tint
    }

}
