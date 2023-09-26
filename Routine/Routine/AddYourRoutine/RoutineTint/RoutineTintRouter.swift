//
//  RoutineTintRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import ModernRIBs

protocol RoutineTintInteractable: Interactable {
    var router: RoutineTintRouting? { get set }
    var listener: RoutineTintListener? { get set }
}

protocol RoutineTintViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RoutineTintRouter: ViewableRouter<RoutineTintInteractable, RoutineTintViewControllable>, RoutineTintRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RoutineTintInteractable, viewController: RoutineTintViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
