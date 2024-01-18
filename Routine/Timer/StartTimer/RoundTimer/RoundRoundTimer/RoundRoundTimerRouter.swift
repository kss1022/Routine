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
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RoundRoundTimerRouter: ViewableRouter<RoundRoundTimerInteractable, RoundRoundTimerViewControllable>, RoundRoundTimerRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RoundRoundTimerInteractable, viewController: RoundRoundTimerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
