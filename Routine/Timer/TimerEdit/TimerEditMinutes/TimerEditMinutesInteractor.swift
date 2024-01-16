//
//  TimerEditMinutesInteractor.swift
//  Routine
//
//  Created by 한현규 on 1/16/24.
//

import Foundation
import ModernRIBs

protocol TimerEditMinutesRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TimerEditMinutesPresentable: Presentable {
    var listener: TimerEditMinutesPresentableListener? { get set }
    func setTimes(hour: Int, minute: Int)
    func showTimePickerAlert(hour: Int, minute: Int)
}

protocol TimerEditMinutesListener: AnyObject {
    func timerEditMinutesSetMinutes(minute: Int)
}

final class TimerEditMinutesInteractor: PresentableInteractor<TimerEditMinutesPresentable>, TimerEditMinutesInteractable, TimerEditMinutesPresentableListener {

    weak var router: TimerEditMinutesRouting?
    weak var listener: TimerEditMinutesListener?

    private var minutes: Int
    private var toHour: Int{ minutes / 60 }
    private var toMinute: Int{ minutes % 60 }
    
    private var longPressTimer: Timer?
    
    // in constructor.
    init(presenter: TimerEditMinutesPresentable, minutes: Int) {
        self.minutes = minutes
        super.init(presenter: presenter)
        presenter.listener = self
    }



    override func didBecomeActive() {
        super.didBecomeActive()
                        
        presenter.setTimes(hour: toHour , minute: toMinute)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    
    func timeLabelDidTap() {
        presenter.showTimePickerAlert(hour: toHour, minute: toMinute)
    }
    
    func countdownAlertDoneButtonDidTap(hour: Int, min: Int) {
        self.minutes = hour * 60 + min
        presenter.setTimes(hour: hour , minute: toMinute)
        listener?.timerEditMinutesSetMinutes(minute: minutes)
    }
    
    func plusButtonDidTap() {
        minutes += 1
        presenter.setTimes(hour: toHour , minute: toMinute)
        listener?.timerEditMinutesSetMinutes(minute: minutes)
    }
    
    func plusBunttonLongPressBegan() {
        startPlusTimer()
    }
    
    func plusButtonLongPressEnded() {
        stopTimer()
    }
    
    func minusButtonDidTap() {
        if minutes <= 1{
            return
        }
        
        minutes -= 1
        presenter.setTimes(hour: toHour , minute: toMinute)
        listener?.timerEditMinutesSetMinutes(minute: minutes)
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
