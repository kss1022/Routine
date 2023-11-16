//
//  AppInfoRouter.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol AppInfoInteractable: Interactable {
    var router: AppInfoRouting? { get set }
    var listener: AppInfoListener? { get set }
}

protocol AppInfoViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AppInfoRouter: ViewableRouter<AppInfoInteractable, AppInfoViewControllable>, AppInfoRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AppInfoInteractable, viewController: AppInfoViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
