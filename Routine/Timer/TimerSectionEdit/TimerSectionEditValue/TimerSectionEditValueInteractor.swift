//
//  TimerSectionEditValueInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs

protocol TimerSectionEditValueRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TimerSectionEditValuePresentable: Presentable {
    var listener: TimerSectionEditValuePresentableListener? { get set }
    
    func showCountDownPicker()
    func showCountPicker()
}

protocol TimerSectionEditValueListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class TimerSectionEditValueInteractor: PresentableInteractor<TimerSectionEditValuePresentable>, TimerSectionEditValueInteractable, TimerSectionEditValuePresentableListener {

    weak var router: TimerSectionEditValueRouting?
    weak var listener: TimerSectionEditValueListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: TimerSectionEditValuePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        //presenter.showCountPicker()
        presenter.showCountDownPicker()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
