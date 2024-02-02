//
//  RoutineBasicInfoRouter.swift
//  Routine
//
//  Created by 한현규 on 10/12/23.
//

import ModernRIBs

protocol RoutineBasicInfoInteractable: Interactable {
    var router: RoutineBasicInfoRouting? { get set }
    var listener: RoutineBasicInfoListener? { get set }
}

protocol RoutineBasicInfoViewControllable: ViewControllable {
}

final class RoutineBasicInfoRouter: ViewableRouter<RoutineBasicInfoInteractable, RoutineBasicInfoViewControllable>, RoutineBasicInfoRouting {

    override init(interactor: RoutineBasicInfoInteractable, viewController: RoutineBasicInfoViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
