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
}

protocol AppTutorialHomeListener: AnyObject {
    func appTutorailHomeDidFinish()
}

final class AppTutorialHomeInteractor: PresentableInteractor<AppTutorialHomePresentable>, AppTutorialHomeInteractable, AppTutorialHomePresentableListener {
    
    weak var router: AppTutorialHomeRouting?
    weak var listener: AppTutorialHomeListener?

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
    }
    
    
    func appTutorialMainContinueButtonDidTap() {
        router?.attachAppTutorialSplash()
    }
    
    func appTutorailSplashDidFinish() {
        listener?.appTutorailHomeDidFinish()
    }
    
}
