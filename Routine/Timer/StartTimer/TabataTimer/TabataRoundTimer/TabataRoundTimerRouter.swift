//
//  TabataRoundTimerRouter.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import ModernRIBs

protocol TabataRoundTimerInteractable: Interactable {
    var router: TabataRoundTimerRouting? { get set }
    var listener: TabataRoundTimerListener? { get set }
}

protocol TabataRoundTimerViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TabataRoundTimerRouter: ViewableRouter<TabataRoundTimerInteractable, TabataRoundTimerViewControllable>, TabataRoundTimerRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TabataRoundTimerInteractable, viewController: TabataRoundTimerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
