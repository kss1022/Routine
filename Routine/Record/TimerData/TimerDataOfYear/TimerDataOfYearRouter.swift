//
//  TimerDataOfYearRouter.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol TimerDataOfYearInteractable: Interactable {
    var router: TimerDataOfYearRouting? { get set }
    var listener: TimerDataOfYearListener? { get set }
}

protocol TimerDataOfYearViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TimerDataOfYearRouter: ViewableRouter<TimerDataOfYearInteractable, TimerDataOfYearViewControllable>, TimerDataOfYearRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TimerDataOfYearInteractable, viewController: TimerDataOfYearViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
