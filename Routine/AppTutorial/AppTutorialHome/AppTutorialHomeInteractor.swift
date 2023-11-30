//
//  AppTutorialHomeInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/27/23.
//

import ModernRIBs

protocol AppTutorialHomeRouting: ViewableRouting {
    func attachAppTutorialMain()
    func attachAppTutorialSplash()
}

protocol AppTutorialHomePresentable: Presentable {
    var listener: AppTutorialHomePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AppTutorialHomeListener: AnyObject {
    func appTutorailHomeDidFinish()
}

final class AppTutorialHomeInteractor: PresentableInteractor<AppTutorialHomePresentable>, AppTutorialHomeInteractable, AppTutorialHomePresentableListener {
    
    weak var router: AppTutorialHomeRouting?
    weak var listener: AppTutorialHomeListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AppTutorialHomePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachAppTutorialMain()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    
    func appTutorialMainContinueButtonDidTap() {
        router?.attachAppTutorialSplash()
    }
    
    func appTutorailSplashDidFinish() {
        listener?.appTutorailHomeDidFinish()
    }
    
}
