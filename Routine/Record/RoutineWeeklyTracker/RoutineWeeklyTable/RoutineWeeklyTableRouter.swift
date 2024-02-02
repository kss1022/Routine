//
//  RoutineWeeklyTableRouter.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol RoutineWeeklyTableInteractable: Interactable {
    var router: RoutineWeeklyTableRouting? { get set }
    var listener: RoutineWeeklyTableListener? { get set }
}

protocol RoutineWeeklyTableViewControllable: ViewControllable {
}

final class RoutineWeeklyTableRouter: ViewableRouter<RoutineWeeklyTableInteractable, RoutineWeeklyTableViewControllable>, RoutineWeeklyTableRouting {

    override init(interactor: RoutineWeeklyTableInteractable, viewController: RoutineWeeklyTableViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
