//
//  AddYourRoutineInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import ModernRIBs

protocol AddYourRoutineRouting: ViewableRouting {
    func attachRoutineTitle()
    func attachRoutineTint()
    func attachRoutineImojiIcon()
}

protocol AddYourRoutinePresentable: Presentable {
    var listener: AddYourRoutinePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AddYourRoutineListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class AddYourRoutineInteractor: PresentableInteractor<AddYourRoutinePresentable>, AddYourRoutineInteractable, AddYourRoutinePresentableListener {

    weak var router: AddYourRoutineRouting?
    weak var listener: AddYourRoutineListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AddYourRoutinePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachRoutineTitle()
        router?.attachRoutineTint()
        router?.attachRoutineImojiIcon()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
