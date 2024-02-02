//
//  RoutineEditRepeatRouter.swift
//  Routine
//
//  Created by 한현규 on 10/9/23.
//

import ModernRIBs

protocol RoutineEditRepeatInteractable: Interactable {
    var router: RoutineEditRepeatRouting? { get set }
    var listener: RoutineEditRepeatListener? { get set }
}

protocol RoutineEditRepeatViewControllable: ViewControllable {
}

final class RoutineEditRepeatRouter: ViewableRouter<RoutineEditRepeatInteractable, RoutineEditRepeatViewControllable>, RoutineEditRepeatRouting {

    override init(interactor: RoutineEditRepeatInteractable, viewController: RoutineEditRepeatViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
