//
//  AppHomeInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs

protocol AppHomeRouting: Routing {
    func cleanupViews()
    func attachTabs()
}

protocol AppHomeListener: AnyObject {
}

final class AppHomeInteractor: Interactor, AppHomeInteractable {

    weak var router: AppHomeRouting?
    weak var listener: AppHomeListener?

    // in constructor.
    override init() {}

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachTabs()
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
    }
}
