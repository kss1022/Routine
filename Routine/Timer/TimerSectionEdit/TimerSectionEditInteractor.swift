//
//  TimerSectionEditInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol TimerSectionEditRouting: ViewableRouting {
    func attachTimerSectionEditTitle()
    func attachTimerEditCountDown()
}

protocol TimerSectionEditPresentable: Presentable {
    var listener: TimerSectionEditPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol TimerSectionEditListener: AnyObject {
    func timerSectionEditDidMoved()
}

final class TimerSectionEditInteractor: PresentableInteractor<TimerSectionEditPresentable>, TimerSectionEditInteractable, TimerSectionEditPresentableListener {

    weak var router: TimerSectionEditRouting?
    weak var listener: TimerSectionEditListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: TimerSectionEditPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachTimerSectionEditTitle()
        router?.attachTimerEditCountDown()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didMoved() {
        listener?.timerSectionEditDidMoved()
    }
    
    
    // MARK: TimerEditCountdown
    func timerEditCountdownValueChange() {
        
    }
    

}
