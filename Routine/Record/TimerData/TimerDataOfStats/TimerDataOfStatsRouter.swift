//
//  TimerDataOfStatsRouter.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol TimerDataOfStatsInteractable: Interactable {
    var router: TimerDataOfStatsRouting? { get set }
    var listener: TimerDataOfStatsListener? { get set }
}

protocol TimerDataOfStatsViewControllable: ViewControllable {
}

final class TimerDataOfStatsRouter: ViewableRouter<TimerDataOfStatsInteractable, TimerDataOfStatsViewControllable>, TimerDataOfStatsRouting {

    override init(interactor: TimerDataOfStatsInteractable, viewController: TimerDataOfStatsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
