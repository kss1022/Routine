//
//  RecordRoutineListRouter.swift
//  Routine
//
//  Created by 한현규 on 11/6/23.
//

import ModernRIBs

protocol RecordRoutineListInteractable: Interactable {
    var router: RecordRoutineListRouting? { get set }
    var listener: RecordRoutineListListener? { get set }
}

protocol RecordRoutineListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RecordRoutineListRouter: ViewableRouter<RecordRoutineListInteractable, RecordRoutineListViewControllable>, RecordRoutineListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RecordRoutineListInteractable, viewController: RecordRoutineListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
