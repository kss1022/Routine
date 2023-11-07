//
//  RoutineDataOfMonthInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RoutineDataOfMonthRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineDataOfMonthPresentable: Presentable {
    var listener: RoutineDataOfMonthPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RoutineDataOfMonthListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RoutineDataOfMonthInteractor: PresentableInteractor<RoutineDataOfMonthPresentable>, RoutineDataOfMonthInteractable, RoutineDataOfMonthPresentableListener {

    weak var router: RoutineDataOfMonthRouting?
    weak var listener: RoutineDataOfMonthListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RoutineDataOfMonthPresentable) {
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
