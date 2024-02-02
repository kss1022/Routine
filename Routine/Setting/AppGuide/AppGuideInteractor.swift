//
//  AppGuideInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol AppGuideRouting: ViewableRouting {
}

protocol AppGuidePresentable: Presentable {
    var listener: AppGuidePresentableListener? { get set }
}

protocol AppGuideListener: AnyObject {
    func appGuideCloseButtonDidTap()
}

final class AppGuideInteractor: PresentableInteractor<AppGuidePresentable>, AppGuideInteractable, AppGuidePresentableListener {

    weak var router: AppGuideRouting?
    weak var listener: AppGuideListener?

    // in constructor.
    override init(presenter: AppGuidePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func closeBarButtonDidTap() {
        listener?.appGuideCloseButtonDidTap()
    }
}
