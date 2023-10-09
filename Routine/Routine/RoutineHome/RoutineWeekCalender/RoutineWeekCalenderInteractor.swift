//
//  RoutineWeekCalenderInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/5/23.
//

import ModernRIBs

protocol RoutineWeekCalenderRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineWeekCalenderPresentable: Presentable {
    var listener: RoutineWeekCalenderPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RoutineWeekCalenderListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RoutineWeekCalenderInteractor: PresentableInteractor<RoutineWeekCalenderPresentable>, RoutineWeekCalenderInteractable, RoutineWeekCalenderPresentableListener {

    weak var router: RoutineWeekCalenderRouting?
    weak var listener: RoutineWeekCalenderListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RoutineWeekCalenderPresentable) {
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
}
