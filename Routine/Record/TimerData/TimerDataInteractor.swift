//
//  TimerDataInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol TimerDataRouting: ViewableRouting {
    func attachTimerDataOfYear()
    func attachTimerDatOfStats()
    func attachTimerTotalRecord()
}

protocol TimerDataPresentable: Presentable {
    var listener: TimerDataPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol TimerDataListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func timerDataDidMove()
}

final class TimerDataInteractor: PresentableInteractor<TimerDataPresentable>, TimerDataInteractable, TimerDataPresentableListener {

    weak var router: TimerDataRouting?
    weak var listener: TimerDataListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: TimerDataPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachTimerDataOfYear()
        router?.attachTimerDatOfStats()        
        router?.attachTimerTotalRecord()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didMove() {
        listener?.timerDataDidMove()
    }
}
