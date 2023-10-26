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
    
    func showCountDownPicker(min: Int, sec: Int)
    func showCountPicker(count: Int)
}

protocol TimerSectionEditValueListener: AnyObject {
    func timerSectionEditValueSetCountdown(min: Int, sec: Int)
    func timerSectionEditValueSetCount(count: Int)    
}

protocol TimerSectionEditValueInteractorDependency{
    var sectionList: TimerSectionListViewModel{ get }
}

final class TimerSectionEditValueInteractor: PresentableInteractor<TimerSectionEditValuePresentable>, TimerSectionEditValueInteractable, TimerSectionEditValuePresentableListener {

    weak var router: TimerSectionEditValueRouting?
    weak var listener: TimerSectionEditValueListener?

    private let dependency: TimerSectionEditValueInteractorDependency
    
    // in constructor.
    init(
        presenter: TimerSectionEditValuePresentable,
        dependency: TimerSectionEditValueInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        switch dependency.sectionList.type {
        case .ready, .rest, .exercise, .cycleRest, .cooldown:
            guard case .countdown(let min,let sec) = dependency.sectionList.value else { return }
            presenter.showCountDownPicker(min: min, sec: sec)
        case .round, .cycle:
            guard case .count(let count) = dependency.sectionList.value else { return }
            presenter.showCountPicker(count: count)
        }
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func countPickerDidValueChange(count: Int) {
        listener?.timerSectionEditValueSetCount(count: count)
    }
    
    func countdownPickerDidValueChange(min: Int, sec: Int) {
        listener?.timerSectionEditValueSetCountdown(min: min, sec: sec)
    }
}
