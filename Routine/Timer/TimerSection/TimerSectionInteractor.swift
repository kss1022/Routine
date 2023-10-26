//
//  TimerSectionInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs

protocol TimerSectionRouting: ViewableRouting {
    func attachTimerRemian()
    func attachCircularTimer()
    func attachTimerNextSection()
}

protocol TimerSectionPresentable: Presentable {
    var listener: TimerSectionPresentableListener? { get set }
}

protocol TimerDetailListener: AnyObject {
    func timerDetailDidTapClose()
}

protocol TimerSectionInteractorDependency{
}

final class TimerSectionInteractor: PresentableInteractor<TimerSectionPresentable>, TimerSectionInteractable, TimerSectionPresentableListener {

    weak var router: TimerSectionRouting?
    weak var listener: TimerDetailListener?

    private let dependency: TimerSectionInteractorDependency
    private var sectionIndex = 0
    
    // in constructor.
    init(
        presenter: TimerSectionPresentable,
        dependency: TimerSectionInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachTimerRemian()
        router?.attachCircularTimer()
        router?.attachTimerNextSection()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    

    //MARK: CircularTimer            
    func circularTimerDidTapCancle() {
        listener?.timerDetailDidTapClose()
    }
    

}
