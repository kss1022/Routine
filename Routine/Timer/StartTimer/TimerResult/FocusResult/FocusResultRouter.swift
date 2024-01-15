//
//  FocusResultRouter.swift
//  Routine
//
//  Created by 한현규 on 10/31/23.
//

import ModernRIBs

protocol FocusResultInteractable: Interactable {
    var router: FocusResultRouting? { get set }
    var listener: FocusResultListener? { get set }
}

protocol FocusResultViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class FocusResultRouter: ViewableRouter<FocusResultInteractable, FocusResultViewControllable>, FocusResultRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: FocusResultInteractable, viewController: FocusResultViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
