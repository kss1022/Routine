//
//  TimerEditTitleRouter.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import ModernRIBs

protocol TimerEditTitleInteractable: Interactable {
    var router: TimerEditTitleRouting? { get set }
    var listener: TimerEditTitleListener? { get set }
}

protocol TimerEditTitleViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TimerEditTitleRouter: ViewableRouter<TimerEditTitleInteractable, TimerEditTitleViewControllable>, TimerEditTitleRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TimerEditTitleInteractable, viewController: TimerEditTitleViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
