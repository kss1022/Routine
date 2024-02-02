//
//  RoutineEditReminderRouter.swift
//  Routine
//
//  Created by 한현규 on 10/13/23.
//

import ModernRIBs

protocol RoutineEditReminderInteractable: Interactable {
    var router: RoutineEditReminderRouting? { get set }
    var listener: RoutineEditReminderListener? { get set }
}

protocol RoutineEditReminderViewControllable: ViewControllable {
}

final class RoutineEditReminderRouter: ViewableRouter<RoutineEditReminderInteractable, RoutineEditReminderViewControllable>, RoutineEditReminderRouting {

    override init(interactor: RoutineEditReminderInteractable, viewController: RoutineEditReminderViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
