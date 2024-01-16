//
//  TimerSectionListViewModel.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import Foundation
import UIKit.UIColor


struct TimerSectionListViewModel: Hashable{
    let id: UUID = UUID()
    let name: String
    let description: String
    let value: String
    let emoji: String
    let color: UIColor?
            
    
    init(_ model: TimerSectionListModel){
        self.name = model.name
        self.description = model.description
        
        if case .count(let count) = model.value{
            self.value = "\(count)"
        }else if case .countdown(let min,let sec) = model.value{
            self.value = String(format: "%02d:%02d", min, sec)
        }else{
            fatalError()
        }        
        
        self.emoji = model.emoji
        self.color  = UIColor(hex: model.tint)
    }

    init(_ model: TimeSectionModel){
        self.name = model.name
        self.description = model.description
        self.value = String(format: "%02d:%02d", model.min, model.sec)
        self.emoji = model.emoji
        self.color  = UIColor(hex: model.tint)
    }
    
    init(_ model: RepeatSectionModel){
        self.name = model.name
        self.description = model.description
        self.value = "\(model.repeat)"
        self.emoji = model.emoji
        self.color  = UIColor(hex: model.tint)
    }
}
