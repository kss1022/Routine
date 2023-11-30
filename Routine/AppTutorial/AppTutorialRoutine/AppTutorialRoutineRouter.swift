//
//  AppTutorialRoutineRouter.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs

protocol AppTutorialRoutineInteractable: Interactable {
    var router: AppTutorialRoutineRouting? { get set }
    var listener: AppTutorialRoutineListener? { get set }
}

protocol AppTutorialRoutineViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AppTutorialRoutineRouter: ViewableRouter<AppTutorialRoutineInteractable, AppTutorialRoutineViewControllable>, AppTutorialRoutineRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AppTutorialRoutineInteractable, viewController: AppTutorialRoutineViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
