//
//  AppTutorialMainInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs

protocol AppTutorialMainRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AppTutorialMainPresentable: Presentable {
    var listener: AppTutorialMainPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AppTutorialMainListener: AnyObject {
    func appTutorialMainContinueButtonDidTap()
}

final class AppTutorialMainInteractor: PresentableInteractor<AppTutorialMainPresentable>, AppTutorialMainInteractable, AppTutorialMainPresentableListener {

    weak var router: AppTutorialMainRouting?
    weak var listener: AppTutorialMainListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AppTutorialMainPresentable) {
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
    
    func continueButtonDidTap() {
        listener?.appTutorialMainContinueButtonDidTap()
    }
}
