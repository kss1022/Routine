//
//  ProfileChartRouter.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol ProfileChartInteractable: Interactable {
    var router: ProfileChartRouting? { get set }
    var listener: ProfileChartListener? { get set }
}

protocol ProfileChartViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProfileChartRouter: ViewableRouter<ProfileChartInteractable, ProfileChartViewControllable>, ProfileChartRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProfileChartInteractable, viewController: ProfileChartViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
