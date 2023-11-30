//
//  AppTutorialMemojiRouter.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs

protocol AppTutorialMemojiInteractable: Interactable {
    var router: AppTutorialMemojiRouting? { get set }
    var listener: AppTutorialMemojiListener? { get set }
}

protocol AppTutorialMemojiViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AppTutorialMemojiRouter: ViewableRouter<AppTutorialMemojiInteractable, AppTutorialMemojiViewControllable>, AppTutorialMemojiRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AppTutorialMemojiInteractable, viewController: AppTutorialMemojiViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
