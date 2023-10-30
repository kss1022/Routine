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
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class FocusRoundTimerRouter: ViewableRouter<FocusRoundTimerInteractable, FocusRoundTimerViewControllable>, FocusRoundTimerRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: FocusRoundTimerInteractable, viewController: FocusRoundTimerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
