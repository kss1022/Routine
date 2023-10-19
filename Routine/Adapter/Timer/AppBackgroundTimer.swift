//
//  AppBackgroundTimer.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation


/**
 *  DispatchSourceTimer
 *  suspend -> release Error!
 *  resume -> resume Error!
 *
 */


final class AppBackgroundTimer: AppTimer {
    
    var remainDuration: ReadOnlyCurrentValuePublisher<TimeInterval>{ remainDurationSubject }
    private let remainDurationSubject = CurrentValuePublisher<TimeInterval>(0)
    
    
    var complete: ReadOnlyPassthroughPublisher<Void>{ completeSubject }
    private let completeSubject = PassthroughPublisher<Void>()


    
    private var timerLock = NSLock()
    private var interval: Int = 100 //milliseconds
    private var eventHandler: (() -> Void)?
    private var completion: (() -> Void)?
    

    //Current State
    private(set) var state = TimerState.initialized
    private var totalDuration: TimeInterval?
    //private(set) var remainDuration: TimeInterval?
    var progress: CGFloat?{
        guard let totalDuration = totalDuration else { return nil}
            
        return remainDuration.value / totalDuration
    }
    
    private var timer: DispatchSourceTimer?
    
    deinit {
        removeTimer()
    }
    
    
    func start(durationSeconds: Double) throws {
        guard case .initialized = state else {
            throw InvalidCastException("Could not start timer. (check state or recreate timer): \(state.rawValue)")
        }
        
        self.totalDuration = durationSeconds
        self.remainDurationSubject.send(durationSeconds)
        
        timer = newTimer()
        timer!.setEventHandler(handler: { [weak self] in
            guard let self = self else { return }
            self.updateTime()
        })
        
                
        activate()
    }

    
    
    private func activate() {
        timerLock.lock()
        timer!.activate()
        state = .resumed
        timerLock.unlock()
        Log.v("App timer: active")
    }
    
    func resume() {
        guard let timer = timer else {
            Log.e("App timer: timer == nil")
            return
        }
        
        timerLock.lock()
        if state == .resumed {
            Log.e("App timer resume fail: state is already resume")
            timerLock.unlock()
            return
        }
        
        timer.resume()
        state = .resumed
        
        timerLock.unlock()
        Log.v("App timer: resume")
    }
    
    func suspend() {
        guard let timer = timer else {
            Log.e("App timer: timer == nil")
            return
        }
        
        timerLock.lock()
        if state == .suspended {
            timerLock.unlock()
            Log.e("App timer resume fail: state is already suspend")
            return
        }
        
        timer.suspend()
        state = .suspended
        
        timerLock.unlock()
        Log.v("App timer: suspend")
    }
    
    func cancel() {
        guard let timer = timer else {
            Log.e("App timer: timer == nil")
            return
        }
        
        timerLock.lock()
        
        if state == .canceled {
            timerLock.unlock()
            Log.e("App timer resume fail: state is already canceled")
            return
        }
        
        if state == .suspended{
            timerLock.unlock()
            resume()
            cancel()
            return
        }
        
        timer.cancel()
        state = .canceled
        
        timerLock.unlock()
        Log.v("App timer: cancle")
    }
    
    private func newTimer() -> DispatchSourceTimer{
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.init(label: "kr.routine.timer"))
        timer.schedule(deadline: .now(), repeating: .milliseconds(self.interval))
        Log.v("App timer new Timer: BackgroundTimer")
        return timer
    }
    
    
    private func updateTime(){        
        if remainDuration.value > 0{
            remainDurationSubject.send(remainDuration.value - 0.1)
        }else{
            Log.v("App timer: finish")
            cancel()
            completion?()
        }
    }

    
    private func removeTimer(){
        eventHandler = nil
        completion = nil
        
        timer?.setEventHandler(handler: nil)
        cancel()
        timer = nil
        Log.v("App timer: RemoveTimer")
    }
    
}
