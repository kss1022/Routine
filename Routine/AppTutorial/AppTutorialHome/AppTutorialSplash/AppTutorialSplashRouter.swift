//
//  AppTutorialSplashRouter.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs

protocol AppTutorialSplashInteractable: Interactable {
    var router: AppTutorialSplashRouting? { get set }
    var listener: AppTutorialSplashListener? { get set }
}

protocol AppTutorialSplashViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AppTutorialSplashRouter: ViewableRouter<AppTutorialSplashInteractable, AppTutorialSplashViewControllable>, AppTutorialSplashRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AppTutorialSplashInteractable, viewController: AppTutorialSplashViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
