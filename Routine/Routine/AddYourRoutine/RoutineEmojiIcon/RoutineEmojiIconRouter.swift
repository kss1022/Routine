//
//  RoutineEmojiIconRouter.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import ModernRIBs

protocol RoutineEmojiIconInteractable: Interactable {
    var router: RoutineEmojiIconRouting? { get set }
    var listener: RoutineEmojiIconListener? { get set }
}

protocol RoutineEmojiIconViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RoutineEmojiIconRouter: ViewableRouter<RoutineEmojiIconInteractable, RoutineEmojiIconViewControllable>, RoutineEmojiIconRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RoutineEmojiIconInteractable, viewController: RoutineEmojiIconViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
