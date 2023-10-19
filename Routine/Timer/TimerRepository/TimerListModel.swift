//
//  TimerListModel.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation


struct TimerListModel{
    let timerId: UUID
    let name: String
    let description: String
    let emoji: String
    let tint: String
    let status: TimerListStatus
}



enum TimerListStatus{
    case initialized
    case start
    case pause
    case end
}
