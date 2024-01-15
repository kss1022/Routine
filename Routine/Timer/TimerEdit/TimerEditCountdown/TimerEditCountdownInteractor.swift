//
//  TimerEditCountdownInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/31/23.
//

import Foundation
import ModernRIBs


protocol TimerEditCountdownRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TimerEditCountdownPresentable: Presentable {
    var listener: TimerEditCountdownPresentableListener? { get set }
    
    func setCountdown(hour: Int, minute: Int)
    func showCountdownPickerAlert(hour: Int, minute: Int)
}

protocol TimerEditCountdownListener: AnyObject {
    func timerEditCountdownSetMinute(minute: Int)
}

final class TimerEditCountdownInteractor: PresentableInteractor<TimerEditCountdownPresentable>, TimerEditCountdownInteractable, TimerEditCountdownPresentableListener {

    weak var router: TimerEditCountdownRouting?
    weak var listener: TimerEditCountdownListener?

    private var minute: Int
    private var toHour: Int{ minute / 60 }
    private var toMinute: Int{ minute % 60 }
    
    private var longPressTimer: Timer?
    
    // in constructor.
    override init(presenter: TimerEditCountdownPresentable) {
        self.minute = 30
        super.init(presenter: presenter)
        presenter.listener = self
    }



    override func didBecomeActive() {
        super.didBecomeActive()
                        
        presenter.setCountdown(hour: toHour , minute: toMinute)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    
    func timeLabelDidTap() {
        presenter.showCountdownPickerAlert(hour: toHour, minute: toMinute)
    }
    
    func countdownAlertDoneButtonDidTap(hour: Int, min: Int) {
        self.minute = hour * 60 + min
        presenter.setCountdown(hour: hour , minute: toMinute)
        listener?.timerEditCountdownSetMinute(minute: minute)
    }
    
    func plusButtonDidTap() {
        minute += 1
        presenter.setCountdown(hour: toHour , minute: toMinute)
        listener?.timerEditCountdownSetMinute(minute: minute)
    }
    
    func plusBunttonLongPressBegan() {
        startPlusTimer()
    }
    
    func plusButtonLongPressEnded() {
        stopTimer()
    }
    
    func minusButtonDidTap() {
        if minute <= 1{
            return
        }
        
        minute -= 1
        presenter.setCountdown(hour: toHour , minute: toMinute)
        listener?.timerEditCountdownSetMinute(minute: minute)
    }
    
    func minusBunttonLongPressBegan() {
        startMinusTimer()
    }
    
    func minusButtonLongPressEnded() {
        stopTimer()
    }
    
    
    
    
    
    private func startPlusTimer(){
        if longPressTimer != nil{
            stopTimer()
        }
        
        longPressTimer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(plusTimerSchedule),
            userInfo: nil,
            repeats: true
        )
    }


    
    
    private func startMinusTimer(){
        if longPressTimer != nil{
            stopTimer()
        }
        
        
        self.longPressTimer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(minusTimerSchedule),
            userInfo: nil,
            repeats: true
        )
    }
    
    
    private func stopTimer(){
        longPressTimer?.invalidate()
        longPressTimer = nil
    }
    
    
    @objc
    private func plusTimerSchedule(){
        plusButtonDidTap()
    }
    
    
    @objc
    private func minusTimerSchedule(){
        minusButtonDidTap()
    }
}
