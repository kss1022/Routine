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
}

final class RecordTimerListRouter: ViewableRouter<RecordTimerListInteractable, RecordTimerListViewControllable>, RecordTimerListRouting {

    override init(interactor: RecordTimerListInteractable, viewController: RecordTimerListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
