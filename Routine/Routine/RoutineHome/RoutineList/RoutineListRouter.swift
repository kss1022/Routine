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
}

final class RoutineListRouter: ViewableRouter<RoutineListInteractable, RoutineListViewControllable>, RoutineListRouting {

    override init(interactor: RoutineListInteractable, viewController: RoutineListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
