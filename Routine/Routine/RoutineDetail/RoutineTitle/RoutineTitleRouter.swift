//
//  RoutineTitleRouter.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import ModernRIBs

protocol RoutineTitleInteractable: Interactable {
    var router: RoutineTitleRouting? { get set }
    var listener: RoutineTitleListener? { get set }
}

protocol RoutineTitleViewControllable: ViewControllable {
}

final class RoutineTitleRouter: ViewableRouter<RoutineTitleInteractable, RoutineTitleViewControllable>, RoutineTitleRouting {

    override init(interactor: RoutineTitleInteractable, viewController: RoutineTitleViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
