//
//  AppTutorialMainRouter.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs

protocol AppTutorialMainInteractable: Interactable {
    var router: AppTutorialMainRouting? { get set }
    var listener: AppTutorialMainListener? { get set }
}

protocol AppTutorialMainViewControllable: ViewControllable {
}

final class AppTutorialMainRouter: ViewableRouter<AppTutorialMainInteractable, AppTutorialMainViewControllable>, AppTutorialMainRouting {

    override init(interactor: AppTutorialMainInteractable, viewController: AppTutorialMainViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
