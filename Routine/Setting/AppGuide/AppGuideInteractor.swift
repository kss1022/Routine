//
//  AppGuideInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol AppGuideRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AppGuidePresentable: Presentable {
    var listener: AppGuidePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AppGuideListener: AnyObject {
    func appGuideCloseButtonDidTap()
}

final class AppGuideInteractor: PresentableInteractor<AppGuidePresentable>, AppGuideInteractable, AppGuidePresentableListener {

    weak var router: AppGuideRouting?
    weak var listener: AppGuideListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AppGuidePresentable) {
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
    
    func closeBarButtonDidTap() {
        listener?.appGuideCloseButtonDidTap()
    }
}
