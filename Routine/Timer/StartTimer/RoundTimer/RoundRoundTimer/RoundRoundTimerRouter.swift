//
//  RoundRoundTimerRouter.swift
//  Routine
//
//  Created by 한현규 on 1/18/24.
//

import ModernRIBs

protocol RoundRoundTimerInteractable: Interactable {
    var router: RoundRoundTimerRouting? { get set }
    var listener: RoundRoundTimerListener? { get set }
}

protocol RoundRoundTimerViewControllable: ViewControllable {
}

final class RoundRoundTimerRouter: ViewableRouter<RoundRoundTimerInteractable, RoundRoundTimerViewControllable>, RoundRoundTimerRouting {

    override init(interactor: RoundRoundTimerInteractable, viewController: RoundRoundTimerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
