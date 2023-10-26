//
//  TimerRemainRouter.swift
//  Routine
//
//  Created by 한현규 on 10/24/23.
//

import ModernRIBs

protocol TimerRemainInteractable: Interactable {
    var router: TimerRemainRouting? { get set }
    var listener: TimerRemainListener? { get set }
}

protocol TimerRemainViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TimerRemainRouter: ViewableRouter<TimerRemainInteractable, TimerRemainViewControllable>, TimerRemainRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TimerRemainInteractable, viewController: TimerRemainViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
