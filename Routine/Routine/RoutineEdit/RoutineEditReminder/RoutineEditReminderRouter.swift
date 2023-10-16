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
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RoutineEditReminderRouter: ViewableRouter<RoutineEditReminderInteractable, RoutineEditReminderViewControllable>, RoutineEditReminderRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RoutineEditReminderInteractable, viewController: RoutineEditReminderViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
