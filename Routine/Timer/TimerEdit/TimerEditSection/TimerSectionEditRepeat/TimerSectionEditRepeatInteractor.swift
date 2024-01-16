//
//  TimerSectionEditRepeatInteractor.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import ModernRIBs

protocol TimerSectionEditRepeatRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TimerSectionEditRepeatPresentable: Presentable {
    var listener: TimerSectionEditRepeatPresentableListener? { get set }
    func setRepeat(repeat: Int)
}

protocol TimerSectionEditRepeatListener: AnyObject {
    func timerSectionEditRepeatDidSetRepeat(repeat: Int)
}

final class TimerSectionEditRepeatInteractor: PresentableInteractor<TimerSectionEditRepeatPresentable>, TimerSectionEditRepeatInteractable, TimerSectionEditRepeatPresentableListener {


    weak var router: TimerSectionEditRepeatRouting?
    weak var listener: TimerSectionEditRepeatListener?

    
    private let `repeat`: Int
    
    // in constructor.
    init(
        presenter: TimerSectionEditRepeatPresentable,
        repeat: Int
    ) {
        self.repeat = `repeat`
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        presenter.setRepeat(repeat: `repeat`)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func countPickerDidValueChange(count: Int) {
        listener?.timerSectionEditRepeatDidSetRepeat(repeat: count)
    }
    
}
