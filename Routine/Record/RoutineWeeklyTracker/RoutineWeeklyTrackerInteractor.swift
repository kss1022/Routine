//
//  RoutineWeeklyTrackerInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol RoutineWeeklyTrackerRouting: ViewableRouting {
    func attachRoutineWeeklyTable()
}

protocol RoutineWeeklyTrackerPresentable: Presentable {
    var listener: RoutineWeeklyTrackerPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RoutineWeeklyTrackerListener: AnyObject {
    func routineWeeklyTrackerDidMove()
}

final class RoutineWeeklyTrackerInteractor: PresentableInteractor<RoutineWeeklyTrackerPresentable>, RoutineWeeklyTrackerInteractable, RoutineWeeklyTrackerPresentableListener {

    weak var router: RoutineWeeklyTrackerRouting?
    weak var listener: RoutineWeeklyTrackerListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RoutineWeeklyTrackerPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachRoutineWeeklyTable()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    
    func didMove() {
        listener?.routineWeeklyTrackerDidMove()
    }
}
