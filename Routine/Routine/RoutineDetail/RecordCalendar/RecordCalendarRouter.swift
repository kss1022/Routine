//
//  RecordCalendarRouter.swift
//  Routine
//
//  Created by 한현규 on 10/12/23.
//

import ModernRIBs

protocol RecordCalendarInteractable: Interactable {
    var router: RecordCalendarRouting? { get set }
    var listener: RecordCalendarListener? { get set }
}

protocol RecordCalendarViewControllable: ViewControllable {
}

final class RecordCalendarRouter: ViewableRouter<RecordCalendarInteractable, RecordCalendarViewControllable>, RecordCalendarRouting {

    override init(interactor: RecordCalendarInteractable, viewController: RecordCalendarViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
