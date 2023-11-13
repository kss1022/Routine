//
//  RecordTimerListDetailRouter.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol RecordTimerListDetailInteractable: Interactable, TimerDataListener {
    var router: RecordTimerListDetailRouting? { get set }
    var listener: RecordTimerListDetailListener? { get set }
}

protocol RecordTimerListDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RecordTimerListDetailRouter: ViewableRouter<RecordTimerListDetailInteractable, RecordTimerListDetailViewControllable>, RecordTimerListDetailRouting {

    private let timerDataBuildable: TimerDataBuildable
    private var timerDataRouting: Routing?
    
    init(
        interactor: RecordTimerListDetailInteractable,
        viewController: RecordTimerListDetailViewControllable,
        timerDataBuildable: TimerDataBuildable
    ) {
        self.timerDataBuildable = timerDataBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTimerData() {
        if timerDataRouting != nil{
            return
        }
        
        let router = timerDataBuildable.build(withListener: interactor)
        viewController.pushViewController(router.viewControllable, animated: true)
        
        timerDataRouting = router
        attachChild(router)
    }
    
    func detachTimerData() {
        guard let router = timerDataRouting else { return }
        
        detachChild(router)
        timerDataRouting = nil
    }
    
}
