//
//  CircularTimerRouter.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs

protocol CircularTimerInteractable: Interactable {
    var router: CircularTimerRouting? { get set }
    var listener: CircularTimerListener? { get set }
}

protocol CircularTimerViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CircularTimerRouter: ViewableRouter<CircularTimerInteractable, CircularTimerViewControllable>, CircularTimerRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CircularTimerInteractable, viewController: CircularTimerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
