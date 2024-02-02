//
//  FontPickerRouter.swift
//  Routine
//
//  Created by 한현규 on 11/17/23.
//

import ModernRIBs

protocol FontPickerInteractable: Interactable {
    var router: FontPickerRouting? { get set }
    var listener: FontPickerListener? { get set }
}

protocol FontPickerViewControllable: ViewControllable {
}

final class FontPickerRouter: ViewableRouter<FontPickerInteractable, FontPickerViewControllable>, FontPickerRouting {

    override init(interactor: FontPickerInteractable, viewController: FontPickerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
