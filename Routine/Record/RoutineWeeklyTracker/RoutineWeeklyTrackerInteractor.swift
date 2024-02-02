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
}

protocol RoutineWeeklyTrackerListener: AnyObject {
    func routineWeeklyTrackerDidMove()
}

final class RoutineWeeklyTrackerInteractor: PresentableInteractor<RoutineWeeklyTrackerPresentable>, RoutineWeeklyTrackerInteractable, RoutineWeeklyTrackerPresentableListener {

    weak var router: RoutineWeeklyTrackerRouting?
    weak var listener: RoutineWeeklyTrackerListener?

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
    }
    
    
    func didMove() {
        listener?.routineWeeklyTrackerDidMove()
    }
}
