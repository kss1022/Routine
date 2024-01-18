//
//  RoundProgressRouter.swift
//  Routine
//
//  Created by 한현규 on 1/18/24.
//

import ModernRIBs

protocol RoundProgressInteractable: Interactable {
    var router: RoundProgressRouting? { get set }
    var listener: RoundProgressListener? { get set }
}

protocol RoundProgressViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RoundProgressRouter: ViewableRouter<RoundProgressInteractable, RoundProgressViewControllable>, RoundProgressRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RoundProgressInteractable, viewController: RoundProgressViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
