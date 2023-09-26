//
//  RoutineImojiIconRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import ModernRIBs

protocol RoutineImojiIconInteractable: Interactable {
    var router: RoutineImojiIconRouting? { get set }
    var listener: RoutineImojiIconListener? { get set }
}

protocol RoutineImojiIconViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RoutineImojiIconRouter: ViewableRouter<RoutineImojiIconInteractable, RoutineImojiIconViewControllable>, RoutineImojiIconRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RoutineImojiIconInteractable, viewController: RoutineImojiIconViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
