//
//  RoutineTotalRecordInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RoutineTotalRecordRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineTotalRecordPresentable: Presentable {
    var listener: RoutineTotalRecordPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RoutineTotalRecordListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RoutineTotalRecordInteractor: PresentableInteractor<RoutineTotalRecordPresentable>, RoutineTotalRecordInteractable, RoutineTotalRecordPresentableListener {

    weak var router: RoutineTotalRecordRouting?
    weak var listener: RoutineTotalRecordListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RoutineTotalRecordPresentable) {
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
