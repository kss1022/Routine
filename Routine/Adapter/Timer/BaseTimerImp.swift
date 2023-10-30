//
//  BaseTimer.swift
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

protocol BaseTimer{
    var timerState: AppTimerState{ get }
    var totalTime: TimeInterval{ get }
    var remainTime: ReadOnlyCurrentValuePublisher<TimeInterval>{ get }
    var completeEvent: ReadOnlyPassthroughPublisher<Void>{ get }
    
    func start()
    func resume()
    func suspend()
    func cancel()
    func complete()
}


class BaseTimerImp: BaseTimer{
    
    public var totalTime: TimeInterval
    public var remainTime: ReadOnlyCurrentValuePublisher<TimeInterval>{ remainTimeSubject }
    private let remainTimeSubject = CurrentValuePublisher<TimeInterval>(-1.0)
    
    public var completeEvent: ReadOnlyPassthroughPublisher<Void>{ completeEventSubject }
    private let completeEventSubject = PassthroughPublisher<Void>()
    
    
    
    private var timer: DispatchSourceTimer?
    public var timerState = AppTimerState.initialized
    
    private var timerLock = NSLock()
    private let interval: Int = 10 //milliseconds
    private lazy var minusTime: Double = Double(interval) / 1000
    
    init(time: Double){
        self.totalTime = time
        self.remainTimeSubject.send(time)
    }
    
    deinit {
        removeTimer()
    }
    
    
    func reset(time: Double){
        self.totalTime = time
        self.remainTimeSubject.send(time)
    }
    
    
    func start()  {
        if timerState != .initialized && timerState != .canceled{
            Log.e("Could not start timer. (check state or recreate timer): \(timerState.rawValue)")
            return
        }
        
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
        timerState = .resumed
        timerLock.unlock()
        Log.v("App timer: active")
    }
    
    func resume() {
        guard let timer = timer else {
            Log.e("App timer resume: timer == nil")
            return
        }
        
        timerLock.lock()
        if timerState == .resumed {
            Log.e("App timer resume fail: state is already resume")
            timerLock.unlock()
            return
        }
        
        timer.resume()
        timerState = .resumed
        
        timerLock.unlock()
        Log.v("App timer: resume")
    }
    
    func suspend() {
        guard let timer = timer else {
            Log.e("App timer suspend: timer == nil")
            return
        }
        
        timerLock.lock()
        if timerState == .suspended {
            timerLock.unlock()
            Log.e("App timer suspend fail: state is already suspend")
            return
        }
        
        timer.suspend()
        timerState = .suspended
        
        timerLock.unlock()
        Log.v("App timer: suspend")
    }
    
    func cancel() {
        guard let timer = timer else {            
            return
        }
        
        timerLock.lock()
        
        if timerState == .canceled {
            timerLock.unlock()
            Log.e("App timer cancel fail: state is already canceled")
            return
        }
        
        if timerState == .suspended{
            timerLock.unlock()
            resume()
            cancel()
            return
        }
        
        timer.cancel()
        timerState = .canceled
        
        timerLock.unlock()
        Log.v("App timer: cancel")
    }
    
    func complete(){
        completeEventSubject.send(Void())
    }
    
    
    private func newTimer() -> DispatchSourceTimer{
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.init(label: "kr.routine.timer"))
        timer.schedule(deadline: .now(), repeating: .milliseconds(self.interval))
        return timer
    }
    
    
    func updateTime(){
        if remainTime.value > 0{
            //Log.v("Update!!! \(remainTime.value)")
            remainTimeSubject.send(remainTime.value - minusTime)
        }else{
            Log.v("App timer: finish")
            cancel()
            complete()
        }
    }
    
    
    private func removeTimer(){
        if timer == nil{
            return 
        }
        
        timer?.setEventHandler(handler: nil)
        
        if timerState != .canceled{
            cancel()
        }
        
        timer = nil
        Log.v("App timer: Remove Timer")
    }
    
    
    
    
}
