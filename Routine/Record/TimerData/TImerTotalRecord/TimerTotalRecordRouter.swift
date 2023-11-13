//
//  TimerTotalRecordRouter.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol TimerTotalRecordInteractable: Interactable {
    var router: TimerTotalRecordRouting? { get set }
    var listener: TimerTotalRecordListener? { get set }
}

protocol TimerTotalRecordViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TimerTotalRecordRouter: ViewableRouter<TimerTotalRecordInteractable, TimerTotalRecordViewControllable>, TimerTotalRecordRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TimerTotalRecordInteractable, viewController: TimerTotalRecordViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
