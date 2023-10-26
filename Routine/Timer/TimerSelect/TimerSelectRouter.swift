//
//  TimerSelectRouter.swift
//  Routine
//
//  Created by 한현규 on 10/26/23.
//

import ModernRIBs

protocol TimerSelectInteractable: Interactable {
    var router: TimerSelectRouting? { get set }
    var listener: TimerSelectListener? { get set }
}

protocol TimerSelectViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TimerSelectRouter: ViewableRouter<TimerSelectInteractable, TimerSelectViewControllable>, TimerSelectRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TimerSelectInteractable, viewController: TimerSelectViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
