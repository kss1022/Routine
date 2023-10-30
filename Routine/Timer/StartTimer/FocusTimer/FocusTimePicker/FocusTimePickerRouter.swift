//
//  FocusTimePickerRouter.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import ModernRIBs

protocol FocusTimePickerInteractable: Interactable {
    var router: FocusTimePickerRouting? { get set }
    var listener: FocusTimePickerListener? { get set }
}

protocol FocusTimePickerViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class FocusTimePickerRouter: ViewableRouter<FocusTimePickerInteractable, FocusTimePickerViewControllable>, FocusTimePickerRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: FocusTimePickerInteractable, viewController: FocusTimePickerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
