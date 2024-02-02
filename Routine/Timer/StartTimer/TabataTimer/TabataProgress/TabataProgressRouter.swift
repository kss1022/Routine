//
//  TabataProgressRouter.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import ModernRIBs

protocol TabataProgressInteractable: Interactable {
    var router: TabataProgressRouting? { get set }
    var listener: TabataProgressListener? { get set }
}

protocol TabataProgressViewControllable: ViewControllable {
}

final class TabataProgressRouter: ViewableRouter<TabataProgressInteractable, TabataProgressViewControllable>, TabataProgressRouting {

    override init(interactor: TabataProgressInteractable, viewController: TabataProgressViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
