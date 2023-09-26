//
//  RoutineTintInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import ModernRIBs

protocol RoutineTintRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineTintPresentable: Presentable {
    var listener: RoutineTintPresentableListener? { get set }
}

protocol RoutineTintListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RoutineTintInteractor: PresentableInteractor<RoutineTintPresentable>, RoutineTintInteractable, RoutineTintPresentableListener {

    weak var router: RoutineTintRouting?
    weak var listener: RoutineTintListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RoutineTintPresentable) {
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
