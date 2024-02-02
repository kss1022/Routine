//
//  CreateRoutineInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/25.
//

import Foundation
import ModernRIBs

protocol CreateRoutineRouting: ViewableRouting {
    func attachAddYourRoutine()
    func detachAddYoutRoutine(dismiss: Bool)
}

protocol CreateRoutinePresentable: Presentable {
    var listener: CreateRoutinePresentableListener? { get set }
}

protocol CreateRoutineListener: AnyObject {
    func createRoutineDismiss()
}

protocol CreateRoutineInteractorDependency{
    var routineRepository: RoutineRepository{ get }
}

final class CreateRoutineInteractor: PresentableInteractor<CreateRoutinePresentable>, CreateRoutineInteractable, CreateRoutinePresentableListener, AdaptivePresentationControllerDelegate {


            
    weak var router: CreateRoutineRouting?
    weak var listener: CreateRoutineListener?
    
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    private let dependency: CreateRoutineInteractorDependency
    
    
    // in constructor.
    init(
        presenter: CreateRoutinePresentable,
        dependency: CreateRoutineInteractorDependency
    ) {
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        self.dependency = dependency
        super.init(presenter: presenter)
        
        presentationDelegateProxy.delegate = self
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func presentationControllerDidDismiss() {
        router?.detachAddYoutRoutine(dismiss: false)
    }
    
    func closeButtonDidTap() {
        listener?.createRoutineDismiss()
    }
    

    // MARK: AddYourOwn
    func addYourOwnButtonDidTap() {
        self.router?.attachAddYourRoutine()
    }
    
    func addYourRoutineCloseButtonDidTap() {
        router?.detachAddYoutRoutine(dismiss: true)
    }
    
    func addYourRoutineDoneButtonDidTap() {
        router?.detachAddYoutRoutine(dismiss: false)
        listener?.createRoutineDismiss()
    }
    
    
}
