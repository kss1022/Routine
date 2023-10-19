//
//  TimerDetailInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs

protocol TimerDetailRouting: ViewableRouting {
    func attachCircularTimer()
    func attachTimerNextSection()
}

protocol TimerDetailPresentable: Presentable {
    var listener: TimerDetailPresentableListener? { get set }
}

protocol TimerDetailListener: AnyObject {
    func timerDetailDidTapClose()
}

protocol TimerDetailInteractorDependency{
    var sectionIndexSubject: CurrentValuePublisher<Int>{ get }
}

final class TimerDetailInteractor: PresentableInteractor<TimerDetailPresentable>, TimerDetailInteractable, TimerDetailPresentableListener {

    weak var router: TimerDetailRouting?
    weak var listener: TimerDetailListener?

    private let dependency: TimerDetailInteractorDependency
    private var sectionIndex = 0
    
    // in constructor.
    init(
        presenter: TimerDetailPresentable,
        dependency: TimerDetailInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        // TODO: Implement business logic here.
        router?.attachCircularTimer()
        router?.attachTimerNextSection()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    

    //MARK: CircularTimer
    func circularTimerDidFinish() {
        self.sectionIndex += 1
        dependency.sectionIndexSubject.send(self.sectionIndex)
    }
    
    func circularTimerDidTapCancle() {
        listener?.timerDetailDidTapClose()
    }
    

}
