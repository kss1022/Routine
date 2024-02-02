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
}

final class TimerDataOfYearRouter: ViewableRouter<TimerDataOfYearInteractable, TimerDataOfYearViewControllable>, TimerDataOfYearRouting {

    override init(interactor: TimerDataOfYearInteractable, viewController: TimerDataOfYearViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
