//
//  RoutineTotalRecordRouter.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RoutineTotalRecordInteractable: Interactable {
    var router: RoutineTotalRecordRouting? { get set }
    var listener: RoutineTotalRecordListener? { get set }
}

protocol RoutineTotalRecordViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RoutineTotalRecordRouter: ViewableRouter<RoutineTotalRecordInteractable, RoutineTotalRecordViewControllable>, RoutineTotalRecordRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RoutineTotalRecordInteractable, viewController: RoutineTotalRecordViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
