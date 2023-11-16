//
//  FeedbackMailRouter.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol FeedbackMailInteractable: Interactable {
    var router: FeedbackMailRouting? { get set }
    var listener: FeedbackMailListener? { get set }
}

protocol FeedbackMailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class FeedbackMailRouter: ViewableRouter<FeedbackMailInteractable, FeedbackMailViewControllable>, FeedbackMailRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: FeedbackMailInteractable, viewController: FeedbackMailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
