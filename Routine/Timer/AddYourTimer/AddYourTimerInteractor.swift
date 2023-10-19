//
//  AddYourTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol AddYourTimerRouting: ViewableRouting {
    func attachTimerSectionEdit()
    func detachTimerSectionEdit()
    
    func attachTimerSectionListection()
}

protocol AddYourTimerPresentable: Presentable {
    var listener: AddYourTimerPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AddYourTimerListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class AddYourTimerInteractor: PresentableInteractor<AddYourTimerPresentable>, AddYourTimerInteractable, AddYourTimerPresentableListener {

    weak var router: AddYourTimerRouting?
    weak var listener: AddYourTimerListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AddYourTimerPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachTimerSectionListection()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    //MARK: TimerSectionList
    func timeSectionListDidSelectRowAt(viewModel: TimerSectionListViewModel) {
        router?.attachTimerSectionEdit()
    }
    
    //MARK: TimerSectionEdit
    func timerSectionEditDidMoved() {
        router?.detachTimerSectionEdit()
    }
}
