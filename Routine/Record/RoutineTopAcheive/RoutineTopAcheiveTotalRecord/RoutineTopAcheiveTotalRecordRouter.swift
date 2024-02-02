//
//  RoutineTopAcheiveTotalRecordRouter.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import ModernRIBs

protocol RoutineTopAcheiveTotalRecordInteractable: Interactable {
    var router: RoutineTopAcheiveTotalRecordRouting? { get set }
    var listener: RoutineTopAcheiveTotalRecordListener? { get set }
}

protocol RoutineTopAcheiveTotalRecordViewControllable: ViewControllable {
}

final class RoutineTopAcheiveTotalRecordRouter: ViewableRouter<RoutineTopAcheiveTotalRecordInteractable, RoutineTopAcheiveTotalRecordViewControllable>, RoutineTopAcheiveTotalRecordRouting {

    override init(interactor: RoutineTopAcheiveTotalRecordInteractable, viewController: RoutineTopAcheiveTotalRecordViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
