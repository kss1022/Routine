//
//  RecordTimerListRouter.swift
//  Routine
//
//  Created by 한현규 on 11/9/23.
//

import ModernRIBs

protocol RecordTimerListInteractable: Interactable {
    var router: RecordTimerListRouting? { get set }
    var listener: RecordTimerListListener? { get set }
}

protocol RecordTimerListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RecordTimerListRouter: ViewableRouter<RecordTimerListInteractable, RecordTimerListViewControllable>, RecordTimerListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RecordTimerListInteractable, viewController: RecordTimerListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
