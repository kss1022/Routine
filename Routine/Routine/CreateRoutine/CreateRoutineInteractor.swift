//
//  CreateRoutineInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/25.
//

import ModernRIBs

protocol CreateRoutineRouting: ViewableRouting {
    func attachAddYourRoutine()
    func detachAddYoutRoutine()
}

protocol CreateRoutinePresentable: Presentable {
    var listener: CreateRoutinePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CreateRoutineListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class CreateRoutineInteractor: PresentableInteractor<CreateRoutinePresentable>, CreateRoutineInteractable, CreateRoutinePresentableListener, AdaptivePresentationControllerDelegate {

            
    weak var router: CreateRoutineRouting?
    weak var listener: CreateRoutineListener?
    
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    // in constructor.
    override init(presenter: CreateRoutinePresentable) {
        presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        super.init(presenter: presenter)
        
        presentationDelegateProxy.delegate = self
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func addYourOwnButtonDidTap() {
        router?.attachAddYourRoutine()
    }
    
    func presentationControllerDidDismiss() {
        router?.detachAddYoutRoutine()
    }
    
    
}
