//
//  TimerEditCountdownRouter.swift
//  Routine
//
//  Created by 한현규 on 10/31/23.
//

import ModernRIBs

protocol TimerEditCountdownInteractable: Interactable {
    var router: TimerEditCountdownRouting? { get set }
    var listener: TimerEditCountdownListener? { get set }
}

protocol TimerEditCountdownViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TimerEditCountdownRouter: ViewableRouter<TimerEditCountdownInteractable, TimerEditCountdownViewControllable>, TimerEditCountdownRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TimerEditCountdownInteractable, viewController: TimerEditCountdownViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
