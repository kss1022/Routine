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
    
    
    private var timers: [String: BaseTimer]
    
    private init() {
        timers = .init()
    }
    
    func baseTimer(appTimerModel: AppTimerModel, timerId: String) -> AppTimer{
        if let timer = timers[timerId] as? AppTimer{
            return timer
        }
        
        let timer = AppTimer(model: appTimerModel)
        timers[timerId] = timer
        return timer                
    }
    
    func removeTimer(timerId: String){
        self.timers[timerId] = nil
    }
    
}
