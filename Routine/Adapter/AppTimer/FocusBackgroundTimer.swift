//
//  FocusBackgroundTimer.swift
//  Routine
//
//  Created by 한현규 on 1/18/24.
//

import Foundation



final class FocusBackgroundTimer: BaseTimerImp{
        
    private var enterBackgroundAt: Date?
    
    override init(_ time: TimeInterval){
        super.init(time)
        setNotifications()
    }
    
    override func start() {
        super.start()
    }
    
    @objc
    private func tiemrEnterBackground(){
        if timerState != .resumed{
            return
        }
        
        enterBackgroundAt = Date()
        suspend()
    }
    
    @objc
    private func timerEnterForeground(){
        guard let enterBackgroundAt = enterBackgroundAt else { return }
        
        let current = Date()
        let backgroundDuration = current.timeIntervalSince(enterBackgroundAt)                
        updateBackgroundTime(backgroundDuration)
        resume()
        
        self.enterBackgroundAt = nil
    }
    
    private func updateBackgroundTime(_ duration: TimeInterval){
        if remainTime.value > duration{
            reset(time: remainTime.value - duration)
            return
        }

        reset(time: 0)
    }
    
    
    private func setNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(timerEnterForeground), name: NSNotification.Name("ENTER_FOREGROUND"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tiemrEnterBackground), name: NSNotification.Name("ENTER_BACKGROUND"), object: nil)
    }
}
