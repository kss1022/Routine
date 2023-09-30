//
//  RoutineTitleRouter.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import ModernRIBs

protocol RoutineTitleInteractable: Interactable {
    var router: RoutineTitleRouting? { get set }
    var listener: RoutineTitleListener? { get set }
}

protocol RoutineTitleViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RoutineTitleRouter: ViewableRouter<RoutineTitleInteractable, RoutineTitleViewControllable>, RoutineTitleRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RoutineTitleInteractable, viewController: RoutineTitleViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
