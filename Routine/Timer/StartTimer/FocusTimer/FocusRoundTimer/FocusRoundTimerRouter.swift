//
//  FocusRoundTimerRouter.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import ModernRIBs

protocol FocusRoundTimerInteractable: Interactable {
    var router: FocusRoundTimerRouting? { get set }
    var listener: FocusRoundTimerListener? { get set }
}

protocol FocusRoundTimerViewControllable: ViewControllable {
}

final class FocusRoundTimerRouter: ViewableRouter<FocusRoundTimerInteractable, FocusRoundTimerViewControllable>, FocusRoundTimerRouting {

    override init(interactor: FocusRoundTimerInteractable, viewController: FocusRoundTimerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
