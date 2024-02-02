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
}

final class AppGuideRouter: ViewableRouter<AppGuideInteractable, AppGuideViewControllable>, AppGuideRouting {
    override init(interactor: AppGuideInteractable, viewController: AppGuideViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
