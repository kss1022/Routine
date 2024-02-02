//
//  RoutineDataOfYearRouter.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RoutineDataOfYearInteractable: Interactable {
    var router: RoutineDataOfYearRouting? { get set }
    var listener: RoutineDataOfYearListener? { get set }
}

protocol RoutineDataOfYearViewControllable: ViewControllable {
}

final class RoutineDataOfYearRouter: ViewableRouter<RoutineDataOfYearInteractable, RoutineDataOfYearViewControllable>, RoutineDataOfYearRouting {

    override init(interactor: RoutineDataOfYearInteractable, viewController: RoutineDataOfYearViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
