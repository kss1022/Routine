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
}

final class RecordBannerRouter: ViewableRouter<RecordBannerInteractable, RecordBannerViewControllable>, RecordBannerRouting {

    override init(interactor: RecordBannerInteractable, viewController: RecordBannerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
