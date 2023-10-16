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
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RoutineBasicInfoRouter: ViewableRouter<RoutineBasicInfoInteractable, RoutineBasicInfoViewControllable>, RoutineBasicInfoRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RoutineBasicInfoInteractable, viewController: RoutineBasicInfoViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
