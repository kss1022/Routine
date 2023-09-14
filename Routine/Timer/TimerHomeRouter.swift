//
//  TimerHomeRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol TimerHomeInteractable: Interactable {
    var router: TimerHomeRouting? { get set }
    var listener: TimerHomeListener? { get set }
}

protocol TimerHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TimerHomeRouter: ViewableRouter<TimerHomeInteractable, TimerHomeViewControllable>, TimerHomeRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TimerHomeInteractable, viewController: TimerHomeViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
