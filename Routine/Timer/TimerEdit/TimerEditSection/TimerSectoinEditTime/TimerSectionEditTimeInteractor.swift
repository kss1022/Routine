//
//  TimerSectionEditTimeInteractor.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import ModernRIBs

protocol TimerSectionEditTimeRouting: ViewableRouting {
}

protocol TimerSectionEditTimePresentable: Presentable {
    var listener: TimerSectionEditTimePresentableListener? { get set }
    func setTimePicker(min: Int, sec: Int)
}

protocol TimerSectionEditTimeListener: AnyObject {
    func timerSectionEditTimeDidSetTime(min: Int, sec: Int)
}

final class TimerSectionEditTimeInteractor: PresentableInteractor<TimerSectionEditTimePresentable>, TimerSectionEditTimeInteractable, TimerSectionEditTimePresentableListener {

    weak var router: TimerSectionEditTimeRouting?
    weak var listener: TimerSectionEditTimeListener?

    
    private let min: Int
    private let sec: Int
    // in constructor.
    init(
        presenter: TimerSectionEditTimePresentable,
        min: Int,
        sec: Int
    ) {
        self.min = min
        self.sec = sec
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        presenter.setTimePicker(min: min, sec: sec)
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func timePickerDidValueChange(min: Int, sec: Int) {
        listener?.timerSectionEditTimeDidSetTime(min: min, sec: sec)
    }
}
