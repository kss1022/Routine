//
//  FontPreviewRouter.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol FontPreviewInteractable: Interactable {
    var router: FontPreviewRouting? { get set }
    var listener: FontPreviewListener? { get set }
}

protocol FontPreviewViewControllable: ViewControllable {
}

final class FontPreviewRouter: ViewableRouter<FontPreviewInteractable, FontPreviewViewControllable>, FontPreviewRouting {

    override init(interactor: FontPreviewInteractable, viewController: FontPreviewViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
