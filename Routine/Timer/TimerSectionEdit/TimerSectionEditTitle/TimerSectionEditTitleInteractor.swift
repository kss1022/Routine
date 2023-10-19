//
//  TimerSectionEditTitleInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol TimerSectionEditTitleRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TimerSectionEditTitlePresentable: Presentable {
    var listener: TimerSectionEditTitlePresentableListener? { get set }
    func setTitle(emoji: String, name: String, description: String)
}

protocol TimerSectionEditTitleListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class TimerSectionEditTitleInteractor: PresentableInteractor<TimerSectionEditTitlePresentable>, TimerSectionEditTitleInteractable, TimerSectionEditTitlePresentableListener {

    weak var router: TimerSectionEditTitleRouting?
    weak var listener: TimerSectionEditTitleListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: TimerSectionEditTitlePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        presenter.setTitle(emoji: "🔥", name: "Ready", description: "Before start CountDown")
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
