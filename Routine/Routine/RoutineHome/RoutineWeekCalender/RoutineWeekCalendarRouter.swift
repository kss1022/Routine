//
//  RoutineWeekCalendarRouter.swift
//  Routine
//
//  Created by 한현규 on 10/5/23.
//

import ModernRIBs

protocol RoutineWeekCalendarInteractable: Interactable {
    var router: RoutineWeekCalendarRouting? { get set }
    var listener: RoutineWeekCalendarListener? { get set }
}

protocol RoutineWeekCalendarViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RoutineWeekCalendarRouter: ViewableRouter<RoutineWeekCalendarInteractable, RoutineWeekCalendarViewControllable>, RoutineWeekCalendarRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RoutineWeekCalendarInteractable, viewController: RoutineWeekCalendarViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
