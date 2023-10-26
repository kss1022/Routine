//
//  TimerNextSectionRouter.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs

protocol TimerNextSectionInteractable: Interactable {
    var router: TimerNextSectionRouting? { get set }
    var listener: TimerNextSectionListener? { get set }
}

protocol TimerNextSectionViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TimerNextSectionRouter: ViewableRouter<TimerNextSectionInteractable, TimerNextSectionViewControllable>, TimerNextSectionRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TimerNextSectionInteractable, viewController: TimerNextSectionViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
