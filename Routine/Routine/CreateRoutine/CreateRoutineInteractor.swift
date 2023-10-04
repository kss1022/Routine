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
    func detachAddYoutRoutine()
}

protocol CreateRoutinePresentable: Presentable {
    var listener: CreateRoutinePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CreateRoutineListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
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
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func addYourOwnButtonDidTap() {
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.routineRepository.fetchTints()
                try await dependency.routineRepository.fetchEmojis()                                
                await MainActor.run { self.router?.attachAddYourRoutine() }
            }catch{
                Log.e("\(error)")
            }
        }
    }
    
    func presentationControllerDidDismiss() {
        router?.detachAddYoutRoutine()
    }
    
    
}