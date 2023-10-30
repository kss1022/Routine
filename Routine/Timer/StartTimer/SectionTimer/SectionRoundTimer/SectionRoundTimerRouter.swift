//
//  SectionRoundTimerRouter.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs

protocol SectionRoundTimerInteractable: Interactable {
    var router: SectionRoundTimerRouting? { get set }
    var listener: SectionRoundTimerListener? { get set }
}

protocol SectionRoundTimerViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SectionRoundTimerRouter: ViewableRouter<SectionRoundTimerInteractable, SectionRoundTimerViewControllable>, SectionRoundTimerRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SectionRoundTimerInteractable, viewController: SectionRoundTimerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
