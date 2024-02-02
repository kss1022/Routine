//
//  TimerListRouter.swift
//  Routine
//
//  Created by 한현규 on 1/15/24.
//

import ModernRIBs

protocol TimerListInteractable: Interactable {
    var router: TimerListRouting? { get set }
    var listener: TimerListListener? { get set }
}

protocol TimerListViewControllable: ViewControllable {
}

final class TimerListRouter: ViewableRouter<TimerListInteractable, TimerListViewControllable>, TimerListRouting {

    override init(interactor: TimerListInteractable, viewController: TimerListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
