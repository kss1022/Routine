//
//  RoutineWeeklyTableInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol RoutineWeeklyTableRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineWeeklyTablePresentable: Presentable {
    var listener: RoutineWeeklyTablePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RoutineWeeklyTableListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RoutineWeeklyTableInteractor: PresentableInteractor<RoutineWeeklyTablePresentable>, RoutineWeeklyTableInteractable, RoutineWeeklyTablePresentableListener {

    weak var router: RoutineWeeklyTableRouting?
    weak var listener: RoutineWeeklyTableListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RoutineWeeklyTablePresentable) {
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
