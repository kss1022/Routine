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
}

final class AppInfoRouter: ViewableRouter<AppInfoInteractable, AppInfoViewControllable>, AppInfoRouting {

    override init(interactor: AppInfoInteractable, viewController: AppInfoViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
