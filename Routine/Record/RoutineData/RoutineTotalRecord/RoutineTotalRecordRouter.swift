//
//  RoutineTotalRecordRouter.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RoutineTotalRecordInteractable: Interactable {
    var router: RoutineTotalRecordRouting? { get set }
    var listener: RoutineTotalRecordListener? { get set }
}

protocol RoutineTotalRecordViewControllable: ViewControllable {
}

final class RoutineTotalRecordRouter: ViewableRouter<RoutineTotalRecordInteractable, RoutineTotalRecordViewControllable>, RoutineTotalRecordRouting {

    override init(interactor: RoutineTotalRecordInteractable, viewController: RoutineTotalRecordViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
