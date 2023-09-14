//
//  RoutineHomeRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol RoutineHomeInteractable: Interactable {
    var router: RoutineHomeRouting? { get set }
    var listener: RoutineHomeListener? { get set }
}

protocol RoutineHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RoutineHomeRouter: ViewableRouter<RoutineHomeInteractable, RoutineHomeViewControllable>, RoutineHomeRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RoutineHomeInteractable, viewController: RoutineHomeViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
