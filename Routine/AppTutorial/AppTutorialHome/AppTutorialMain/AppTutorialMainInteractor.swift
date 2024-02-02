//
//  AppTutorialMainInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs

protocol AppTutorialMainRouting: ViewableRouting {
}

protocol AppTutorialMainPresentable: Presentable {
    var listener: AppTutorialMainPresentableListener? { get set }
}

protocol AppTutorialMainListener: AnyObject {
    func appTutorialMainContinueButtonDidTap()
}

final class AppTutorialMainInteractor: PresentableInteractor<AppTutorialMainPresentable>, AppTutorialMainInteractable, AppTutorialMainPresentableListener {

    weak var router: AppTutorialMainRouting?
    weak var listener: AppTutorialMainListener?

    // in constructor.
    override init(presenter: AppTutorialMainPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func continueButtonDidTap() {
        listener?.appTutorialMainContinueButtonDidTap()
    }
}
