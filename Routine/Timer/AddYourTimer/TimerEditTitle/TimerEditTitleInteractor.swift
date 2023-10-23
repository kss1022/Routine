//
//  TimerEditTitleInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import ModernRIBs

protocol TimerEditTitleRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TimerEditTitlePresentable: Presentable {
    var listener: TimerEditTitlePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol TimerEditTitleListener: AnyObject {
    func timerEditTitleSetName(name: String)
}

final class TimerEditTitleInteractor: PresentableInteractor<TimerEditTitlePresentable>, TimerEditTitleInteractable, TimerEditTitlePresentableListener {


    weak var router: TimerEditTitleRouting?
    weak var listener: TimerEditTitleListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: TimerEditTitlePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func setTimerName(name: String) {
        listener?.timerEditTitleSetName(name: name)
    }
    
}
