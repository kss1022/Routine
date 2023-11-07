//
//  RoutineDataOfYearInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RoutineDataOfYearRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineDataOfYearPresentable: Presentable {
    var listener: RoutineDataOfYearPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RoutineDataOfYearListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RoutineDataOfYearInteractor: PresentableInteractor<RoutineDataOfYearPresentable>, RoutineDataOfYearInteractable, RoutineDataOfYearPresentableListener {

    weak var router: RoutineDataOfYearRouting?
    weak var listener: RoutineDataOfYearListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RoutineDataOfYearPresentable) {
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
