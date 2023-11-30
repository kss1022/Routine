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
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AppTutorialTimerRouter: ViewableRouter<AppTutorialTimerInteractable, AppTutorialTimerViewControllable>, AppTutorialTimerRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AppTutorialTimerInteractable, viewController: AppTutorialTimerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
