//
//  RoutineWeekCalenderRouter.swift
//  Routine
//
//  Created by 한현규 on 10/5/23.
//

import ModernRIBs

protocol RoutineWeekCalenderInteractable: Interactable {
    var router: RoutineWeekCalenderRouting? { get set }
    var listener: RoutineWeekCalenderListener? { get set }
}

protocol RoutineWeekCalenderViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RoutineWeekCalenderRouter: ViewableRouter<RoutineWeekCalenderInteractable, RoutineWeekCalenderViewControllable>, RoutineWeekCalenderRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RoutineWeekCalenderInteractable, viewController: RoutineWeekCalenderViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
