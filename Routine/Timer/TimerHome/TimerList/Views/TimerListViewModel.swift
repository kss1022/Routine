//
//  TimerListViewModel.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import Foundation

struct TimerListViewModel: Hashable{
    let timerId: UUID
    let name: String
    let emoji: String
    
    init(_ model: TimerListModel) {
        self.timerId = model.timerId
        self.name = model.name
        self.emoji = model.emoji
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(timerId)
        hasher.combine(name)
        hasher.combine(emoji)
    }
    
    static func ==(lsh: TimerListViewModel, rhs: TimerListViewModel){
        lsh.timerId == rhs.timerId && lsh.name == rhs.name &&
        lsh.emoji == rhs.emoji
    }

}
