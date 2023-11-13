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
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TimerDataOfStatsRouter: ViewableRouter<TimerDataOfStatsInteractable, TimerDataOfStatsViewControllable>, TimerDataOfStatsRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TimerDataOfStatsInteractable, viewController: TimerDataOfStatsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
