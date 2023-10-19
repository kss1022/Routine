//
//  AppTimerManager.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation
import Combine


protocol AppTimer {
    
    var state: TimerState { get }
    
    var remainDuration: ReadOnlyCurrentValuePublisher<TimeInterval>{ get }
    var complete: ReadOnlyPassthroughPublisher<Void>{ get }
    
    func start(durationSeconds: Double) throws
    func resume()
    func suspend()
    func cancel()
}


enum TimerState: String {
    case initialized
    case suspended
    case resumed
    case canceled
}


final class AppTimerManager{
    
    
    public static let share = AppTimerManager()
    
    
    private var timers: [String: AppTimer]
    
    private init() {
        timers = .init()
    }
    
    func timer(id: String) -> AppTimer{
        if let timer = timers[id],
           timer.state != .canceled{
            return timer
        }
        
        let timer = AppBackgroundTimer()
        timers[id] = timer
        return timer
    }
    
}
