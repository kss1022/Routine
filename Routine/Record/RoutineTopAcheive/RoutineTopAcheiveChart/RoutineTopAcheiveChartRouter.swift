//
//  RoutineTopAcheiveChartRouter.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import ModernRIBs

protocol RoutineTopAcheiveChartInteractable: Interactable {
    var router: RoutineTopAcheiveChartRouting? { get set }
    var listener: RoutineTopAcheiveChartListener? { get set }
}

protocol RoutineTopAcheiveChartViewControllable: ViewControllable {
}

final class RoutineTopAcheiveChartRouter: ViewableRouter<RoutineTopAcheiveChartInteractable, RoutineTopAcheiveChartViewControllable>, RoutineTopAcheiveChartRouting {

    override init(interactor: RoutineTopAcheiveChartInteractable, viewController: RoutineTopAcheiveChartViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
