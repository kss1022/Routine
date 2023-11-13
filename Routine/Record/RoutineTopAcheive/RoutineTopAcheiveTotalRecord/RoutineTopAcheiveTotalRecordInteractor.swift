//
//  RoutineTopAcheiveTotalRecordInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import ModernRIBs

protocol RoutineTopAcheiveTotalRecordRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineTopAcheiveTotalRecordPresentable: Presentable {
    var listener: RoutineTopAcheiveTotalRecordPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RoutineTopAcheiveTotalRecordListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RoutineTopAcheiveTotalRecordInteractor: PresentableInteractor<RoutineTopAcheiveTotalRecordPresentable>, RoutineTopAcheiveTotalRecordInteractable, RoutineTopAcheiveTotalRecordPresentableListener {

    weak var router: RoutineTopAcheiveTotalRecordRouting?
    weak var listener: RoutineTopAcheiveTotalRecordListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RoutineTopAcheiveTotalRecordPresentable) {
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
