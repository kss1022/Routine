//
//  RecordRoutineListDetailRouter.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RecordRoutineListDetailInteractable: Interactable {
    var router: RecordRoutineListDetailRouting? { get set }
    var listener: RecordRoutineListDetailListener? { get set }
}

protocol RecordRoutineListDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RecordRoutineListDetailRouter: ViewableRouter<RecordRoutineListDetailInteractable, RecordRoutineListDetailViewControllable>, RecordRoutineListDetailRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RecordRoutineListDetailInteractable, viewController: RecordRoutineListDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
