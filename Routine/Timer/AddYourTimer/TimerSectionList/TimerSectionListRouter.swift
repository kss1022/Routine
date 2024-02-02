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
}

final class TimerSectionListRouter: ViewableRouter<TimerSectionListInteractable, TimerSectionListViewControllable>, TimerSectionListRouting {

    override init(interactor: TimerSectionListInteractable, viewController: TimerSectionListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
