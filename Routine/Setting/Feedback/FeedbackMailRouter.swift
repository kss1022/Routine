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
}

final class FeedbackMailRouter: ViewableRouter<FeedbackMailInteractable, FeedbackMailViewControllable>, FeedbackMailRouting {

    override init(interactor: FeedbackMailInteractable, viewController: FeedbackMailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
