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
}

final class TimerSectionEditTitleRouter: ViewableRouter<TimerSectionEditTitleInteractable, TimerSectionEditTitleViewControllable>, TimerSectionEditTitleRouting {

    override init(interactor: TimerSectionEditTitleInteractable, viewController: TimerSectionEditTitleViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
