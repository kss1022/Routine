//
//  RecordHomeRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol RecordHomeInteractable: Interactable {
    var router: RecordHomeRouting? { get set }
    var listener: RecordHomeListener? { get set }
}

protocol RecordHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RecordHomeRouter: ViewableRouter<RecordHomeInteractable, RecordHomeViewControllable>, RecordHomeRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RecordHomeInteractable, viewController: RecordHomeViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
