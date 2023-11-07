//
//  RecordHomeRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol RecordHomeInteractable: Interactable,RecordRoutineListDetailListener, RoutineDataListener, RecordBannerListener, RecordRoutineListListener {
    var router: RecordHomeRouting? { get set }
    var listener: RecordHomeListener? { get set }
}

protocol RecordHomeViewControllable: ViewControllable {
    func setBanner(_ view: ViewControllable)
    func setRoutineList(_ view: ViewControllable)
}

final class RecordHomeRouter: ViewableRouter<RecordHomeInteractable, RecordHomeViewControllable>, RecordHomeRouting {

    private let recordRoutineListDetailBuildable: RecordRoutineListDetailBuildable
    private var recordRoutineListDetailRouting: Routing?

    private let routineDataBuildable: RoutineDataBuildable
    private var routineDataRouting: Routing?
    
    private let recordBannerBuildable: RecordBannerBuildable
    private var recordBannerRouting: Routing?

    private let recordRoutineListBuildable: RecordRoutineListBuildable
    private var recordRoutineListRouting: Routing?
    
    
    init(
        interactor: RecordHomeInteractable,
        viewController: RecordHomeViewControllable,
        recordRoutineListDetailBuildable: RecordRoutineListDetailBuildable,
        routineDataBuildable: RoutineDataBuildable,
        recordBannerBuildable: RecordBannerBuildable,
        recordRoutineListBuildable: RecordRoutineListBuildable
    ) {
        self.recordRoutineListDetailBuildable = recordRoutineListDetailBuildable
        self.routineDataBuildable = routineDataBuildable
        self.recordBannerBuildable = recordBannerBuildable
        self.recordRoutineListBuildable = recordRoutineListBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    func attachRecordRoutineListDetail() {
        if recordRoutineListDetailRouting != nil{
            return
        }
        
        let router = recordRoutineListDetailBuildable.build(withListener: interactor)        
        viewController.pushViewController(router.viewControllable, animated: true)
        
        recordRoutineListDetailRouting = router
        attachChild(router)
    }
    
    func detachRecordRoutineListDetail() {
        guard let router = recordRoutineListDetailRouting else { return }
        
        detachChild(router)
        recordRoutineListDetailRouting = nil
    }
    
    func attachRoutineData() {
        if routineDataRouting != nil{
            return
        }
        
        let router = routineDataBuildable.build(withListener: interactor)
        viewController.pushViewController(router.viewControllable, animated: true)
        
        routineDataRouting = router
        attachChild(router)
    }
    
    func detachRoutineData() {
        guard let router = routineDataRouting else { return }
        
        detachChild(router)
        routineDataRouting = nil
    }
    
    
    func attachRecordBanner() {
        if recordBannerRouting != nil{
            return
        }
        
        let router = recordBannerBuildable.build(withListener: interactor)
        viewController.setBanner(router.viewControllable)
        
        recordBannerRouting = router
        attachChild(router)
    }
    
    func attachRecordRoutineList() {
        if recordRoutineListRouting != nil{
            return
        }
        
        let router = recordRoutineListBuildable.build(withListener: interactor)
        viewController.setRoutineList(router.viewControllable)
        
        recordRoutineListRouting = router
        attachChild(router)
    }
    

    
}
