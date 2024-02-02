//
//  AppTutorialTimerRouter.swift
//  Routine
//
//  Created by 한현규 on 11/29/23.
//

import ModernRIBs

protocol AppTutorialTimerInteractable: Interactable {
    var router: AppTutorialTimerRouting? { get set }
    var listener: AppTutorialTimerListener? { get set }
}

protocol AppTutorialTimerViewControllable: ViewControllable {
}

final class AppTutorialTimerRouter: ViewableRouter<AppTutorialTimerInteractable, AppTutorialTimerViewControllable>, AppTutorialTimerRouting {

    override init(interactor: AppTutorialTimerInteractable, viewController: AppTutorialTimerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
