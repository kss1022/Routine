//
//  AppGuideRouter.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol AppGuideInteractable: Interactable {
    var router: AppGuideRouting? { get set }
    var listener: AppGuideListener? { get set }
}

protocol AppGuideViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AppGuideRouter: ViewableRouter<AppGuideInteractable, AppGuideViewControllable>, AppGuideRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AppGuideInteractable, viewController: AppGuideViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
