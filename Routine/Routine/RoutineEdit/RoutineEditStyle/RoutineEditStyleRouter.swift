//
//  RoutineEditStyleRouter.swift
//  Routine
//
//  Created by 한현규 on 11/30/23.
//

import ModernRIBs

protocol RoutineEditStyleInteractable: Interactable {
    var router: RoutineEditStyleRouting? { get set }
    var listener: RoutineEditStyleListener? { get set }
}

protocol RoutineEditStyleViewControllable: ViewControllable {
}

final class RoutineEditStyleRouter: ViewableRouter<RoutineEditStyleInteractable, RoutineEditStyleViewControllable>, RoutineEditStyleRouting {

    override init(interactor: RoutineEditStyleInteractable, viewController: RoutineEditStyleViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
