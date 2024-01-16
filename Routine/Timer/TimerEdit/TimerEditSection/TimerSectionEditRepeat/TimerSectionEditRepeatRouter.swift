//
//  TimerSectionEditRepeatRouter.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import ModernRIBs

protocol TimerSectionEditRepeatInteractable: Interactable {
    var router: TimerSectionEditRepeatRouting? { get set }
    var listener: TimerSectionEditRepeatListener? { get set }
}

protocol TimerSectionEditRepeatViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TimerSectionEditRepeatRouter: ViewableRouter<TimerSectionEditRepeatInteractable, TimerSectionEditRepeatViewControllable>, TimerSectionEditRepeatRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TimerSectionEditRepeatInteractable, viewController: TimerSectionEditRepeatViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
