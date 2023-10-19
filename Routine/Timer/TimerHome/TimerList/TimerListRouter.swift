//
//  TimerListRouter.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol TimerListInteractable: Interactable {
    var router: TimerListRouting? { get set }
    var listener: TimerListListener? { get set }
}

protocol TimerListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TimerListRouter: ViewableRouter<TimerListInteractable, TimerListViewControllable>, TimerListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TimerListInteractable, viewController: TimerListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
