//
//  FocusTimerManager.swift
//  Routine
//
//  Created by 한현규 on 1/18/24.
//

import Foundation



protocol TimerUserInterface{
    func startTimer()
    func suspendTimer()
    func resumeTimer()
    func cancelTimer()
}


protocol TimerEvent{
    func updateTimer(minutes: Int)
}
