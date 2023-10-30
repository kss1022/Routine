//
//  AppTimerManager.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation
import Combine




final class AppTimerManager{
    
    
    public static let share = AppTimerManager()
    
    
    private var timers: [UUID: BaseTimer]
    
    private init() {
        timers = .init()
    }
    
    func baseTimer(model: AppTimerModel, id: UUID) -> AppTimer{
        if let timer = timers[id] as? AppTimer{
            return timer
        }
        
        let timer = AppTimer(model: model)
        timers[id] = timer
        return timer                
    }
    
    func focusTimer(model: AppFocusTimerModel, id: UUID) -> AppFocusTimer{
        if let timer = timers[id] as? AppFocusTimer{
            return timer
        }
        
        let timer = AppFocusTimer(model: model)
        timers[id] = timer
        return timer
    }
    
    func removeTimer(id: UUID){
        self.timers[id] = nil
    }
    
}
