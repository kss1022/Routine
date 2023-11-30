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
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AppTutorialMainRouter: ViewableRouter<AppTutorialMainInteractable, AppTutorialMainViewControllable>, AppTutorialMainRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AppTutorialMainInteractable, viewController: AppTutorialMainViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
