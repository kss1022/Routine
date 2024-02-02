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
}

final class AppTutorialMemojiRouter: ViewableRouter<AppTutorialMemojiInteractable, AppTutorialMemojiViewControllable>, AppTutorialMemojiRouting {

    override init(interactor: AppTutorialMemojiInteractable, viewController: AppTutorialMemojiViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
