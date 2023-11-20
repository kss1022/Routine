//
//  AppFontListRouter.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol AppFontListInteractable: Interactable {
    var router: AppFontListRouting? { get set }
    var listener: AppFontListListener? { get set }
}

protocol AppFontListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AppFontListRouter: ViewableRouter<AppFontListInteractable, AppFontListViewControllable>, AppFontListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AppFontListInteractable, viewController: AppFontListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
