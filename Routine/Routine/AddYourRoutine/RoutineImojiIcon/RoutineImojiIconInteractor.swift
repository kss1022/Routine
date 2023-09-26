//
//  RoutineImojiIconInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import ModernRIBs

protocol RoutineImojiIconRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineImojiIconPresentable: Presentable {
    var listener: RoutineImojiIconPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RoutineImojiIconListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RoutineImojiIconInteractor: PresentableInteractor<RoutineImojiIconPresentable>, RoutineImojiIconInteractable, RoutineImojiIconPresentableListener {

    weak var router: RoutineImojiIconRouting?
    weak var listener: RoutineImojiIconListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RoutineImojiIconPresentable) {
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
