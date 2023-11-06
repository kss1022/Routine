//
//  RecordHomeRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol RecordHomeInteractable: Interactable, RecordBannerListener {
    var router: RecordHomeRouting? { get set }
    var listener: RecordHomeListener? { get set }
}

protocol RecordHomeViewControllable: ViewControllable {
    func setBanner(_ view: ViewControllable)
}

final class RecordHomeRouter: ViewableRouter<RecordHomeInteractable, RecordHomeViewControllable>, RecordHomeRouting {

    
    private let recordBannerBuildable: RecordBannerBuildable
    private var recordBannerRouting: Routing?

    
    init(
        interactor: RecordHomeInteractable,
        viewController: RecordHomeViewControllable,
        recordBannerBuildable: RecordBannerBuildable
    ) {
        self.recordBannerBuildable = recordBannerBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    func appendRecordBanner() {
        if recordBannerRouting != nil{
            return
        }
        
        let router = recordBannerBuildable.build(withListener: interactor)
        viewController.setBanner(router.viewControllable)
        
        recordBannerRouting = router
        attachChild(router)
    }
}
