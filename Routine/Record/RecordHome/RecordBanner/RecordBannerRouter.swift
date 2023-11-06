//
//  RecordBannerRouter.swift
//  Routine
//
//  Created by 한현규 on 11/2/23.
//

import ModernRIBs

protocol RecordBannerInteractable: Interactable {
    var router: RecordBannerRouting? { get set }
    var listener: RecordBannerListener? { get set }
}

protocol RecordBannerViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RecordBannerRouter: ViewableRouter<RecordBannerInteractable, RecordBannerViewControllable>, RecordBannerRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RecordBannerInteractable, viewController: RecordBannerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
