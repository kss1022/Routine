//
//  RoutineEditTitleRouter.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import ModernRIBs

protocol RoutineEditTitleInteractable: Interactable {
    var router: RoutineEditTitleRouting? { get set }
    var listener: RoutineEditTitleListener? { get set }
}

protocol RoutineEditTitleViewControllable: ViewControllable {
}

final class RoutineEditTitleRouter: ViewableRouter<RoutineEditTitleInteractable, RoutineEditTitleViewControllable>, RoutineEditTitleRouting {

    override init(interactor: RoutineEditTitleInteractable, viewController: RoutineEditTitleViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
