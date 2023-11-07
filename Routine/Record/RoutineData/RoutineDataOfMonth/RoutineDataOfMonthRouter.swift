//
//  RoutineDataOfMonthRouter.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RoutineDataOfMonthInteractable: Interactable {
    var router: RoutineDataOfMonthRouting? { get set }
    var listener: RoutineDataOfMonthListener? { get set }
}

protocol RoutineDataOfMonthViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RoutineDataOfMonthRouter: ViewableRouter<RoutineDataOfMonthInteractable, RoutineDataOfMonthViewControllable>, RoutineDataOfMonthRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RoutineDataOfMonthInteractable, viewController: RoutineDataOfMonthViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
