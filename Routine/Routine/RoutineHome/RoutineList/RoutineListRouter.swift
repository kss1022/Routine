//
//  RoutineListRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/27.
//

import ModernRIBs

protocol RoutineListInteractable: Interactable {
    var router: RoutineListRouting? { get set }
    var listener: RoutineListListener? { get set }
}

protocol RoutineListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RoutineListRouter: ViewableRouter<RoutineListInteractable, RoutineListViewControllable>, RoutineListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RoutineListInteractable, viewController: RoutineListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
