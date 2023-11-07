//
//  RoutineDataOfWeekRouter.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RoutineDataOfWeekInteractable: Interactable {
    var router: RoutineDataOfWeekRouting? { get set }
    var listener: RoutineDataOfWeekListener? { get set }
}

protocol RoutineDataOfWeekViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RoutineDataOfWeekRouter: ViewableRouter<RoutineDataOfWeekInteractable, RoutineDataOfWeekViewControllable>, RoutineDataOfWeekRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RoutineDataOfWeekInteractable, viewController: RoutineDataOfWeekViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
