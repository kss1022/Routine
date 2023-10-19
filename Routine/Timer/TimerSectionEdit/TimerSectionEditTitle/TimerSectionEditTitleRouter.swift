//
//  TimerSectionEditTitleRouter.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol TimerSectionEditTitleInteractable: Interactable {
    var router: TimerSectionEditTitleRouting? { get set }
    var listener: TimerSectionEditTitleListener? { get set }
}

protocol TimerSectionEditTitleViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TimerSectionEditTitleRouter: ViewableRouter<TimerSectionEditTitleInteractable, TimerSectionEditTitleViewControllable>, TimerSectionEditTitleRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TimerSectionEditTitleInteractable, viewController: TimerSectionEditTitleViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
