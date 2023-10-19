//
//  TimerSectionListRouter.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol TimerSectionListInteractable: Interactable {
    var router: TimerSectionListRouting? { get set }
    var listener: TimerSectionListListener? { get set }
}

protocol TimerSectionListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TimerSectionListRouter: ViewableRouter<TimerSectionListInteractable, TimerSectionListViewControllable>, TimerSectionListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TimerSectionListInteractable, viewController: TimerSectionListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
