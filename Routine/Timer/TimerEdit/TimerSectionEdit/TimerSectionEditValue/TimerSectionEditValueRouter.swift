//
//  TimerSectionEditValueRouter.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs

protocol TimerSectionEditValueInteractable: Interactable {
    var router: TimerSectionEditValueRouting? { get set }
    var listener: TimerSectionEditValueListener? { get set }
}

protocol TimerSectionEditValueViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TimerSectionEditValueRouter: ViewableRouter<TimerSectionEditValueInteractable, TimerSectionEditValueViewControllable>, TimerSectionEditValueRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TimerSectionEditValueInteractable, viewController: TimerSectionEditValueViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
