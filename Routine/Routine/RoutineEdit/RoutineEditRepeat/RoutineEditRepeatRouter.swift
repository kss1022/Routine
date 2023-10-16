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
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RoutineEditRepeatRouter: ViewableRouter<RoutineEditRepeatInteractable, RoutineEditRepeatViewControllable>, RoutineEditRepeatRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RoutineEditRepeatInteractable, viewController: RoutineEditRepeatViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
