//
//  TimerSectionEditRepeatRouter.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import ModernRIBs

protocol TimerSectionEditRepeatInteractable: Interactable {
    var router: TimerSectionEditRepeatRouting? { get set }
    var listener: TimerSectionEditRepeatListener? { get set }
}

protocol TimerSectionEditRepeatViewControllable: ViewControllable {
}

final class TimerSectionEditRepeatRouter: ViewableRouter<TimerSectionEditRepeatInteractable, TimerSectionEditRepeatViewControllable>, TimerSectionEditRepeatRouting {

    override init(interactor: TimerSectionEditRepeatInteractable, viewController: TimerSectionEditRepeatViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
