//
//  AppInfoInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol AppInfoRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AppInfoPresentable: Presentable {
    var listener: AppInfoPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AppInfoListener: AnyObject {
    func appInfoCloseButtonDidTap()
}

final class AppInfoInteractor: PresentableInteractor<AppInfoPresentable>, AppInfoInteractable, AppInfoPresentableListener {

    weak var router: AppInfoRouting?
    weak var listener: AppInfoListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AppInfoPresentable) {
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
        listener?.appInfoCloseButtonDidTap()
    }
}
