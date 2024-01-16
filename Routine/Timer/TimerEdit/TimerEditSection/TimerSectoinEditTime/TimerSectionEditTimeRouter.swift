//
//  TimerSectionEditTimeRouter.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import ModernRIBs

protocol TimerSectionEditTimeInteractable: Interactable {
    var router: TimerSectionEditTimeRouting? { get set }
    var listener: TimerSectionEditTimeListener? { get set }
}

protocol TimerSectionEditTimeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TimerSectionEditTimeRouter: ViewableRouter<TimerSectionEditTimeInteractable, TimerSectionEditTimeViewControllable>, TimerSectionEditTimeRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TimerSectionEditTimeInteractable, viewController: TimerSectionEditTimeViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
