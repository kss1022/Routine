//
//  TimerEditMinutesRouter.swift
//  Routine
//
//  Created by 한현규 on 1/16/24.
//

import ModernRIBs

protocol TimerEditMinutesInteractable: Interactable {
    var router: TimerEditMinutesRouting? { get set }
    var listener: TimerEditMinutesListener? { get set }
}

protocol TimerEditMinutesViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TimerEditMinutesRouter: ViewableRouter<TimerEditMinutesInteractable, TimerEditMinutesViewControllable>, TimerEditMinutesRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TimerEditMinutesInteractable, viewController: TimerEditMinutesViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
