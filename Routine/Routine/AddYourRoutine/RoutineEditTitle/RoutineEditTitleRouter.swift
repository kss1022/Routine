//
//  RoutineEditTitleRouter.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import ModernRIBs

protocol RoutineEditTitleInteractable: Interactable {
    var router: RoutineEditTitleRouting? { get set }
    var listener: RoutineEditTitleListener? { get set }
}

protocol RoutineEditTitleViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RoutineEditTitleRouter: ViewableRouter<RoutineEditTitleInteractable, RoutineEditTitleViewControllable>, RoutineEditTitleRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RoutineEditTitleInteractable, viewController: RoutineEditTitleViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
