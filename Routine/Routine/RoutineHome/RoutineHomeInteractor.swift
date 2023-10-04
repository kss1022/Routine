//
//  RoutineHomeInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs
import Combine
import Foundation

protocol RoutineHomeRouting: ViewableRouting {
    func attachCreateRoutine()
    func detachCreateRoutine()
    
    func attachRoutineDetail(routineId: UUID)
    func detachRoutineDetail()
    
    func attachRoutineList()
}

protocol RoutineHomePresentable: Presentable {
    var listener: RoutineHomePresentableListener? { get set }
}

protocol RoutineHomeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol RoutineHomeInteractorDependency{
    var routineApplicationService: RoutineApplicationService{ get }
    var routineRepository: RoutineRepository{ get }
}

final class RoutineHomeInteractor: PresentableInteractor<RoutineHomePresentable>, RoutineHomeInteractable, RoutineHomePresentableListener, AdaptivePresentationControllerDelegate {


    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    
    weak var router: RoutineHomeRouting?
    weak var listener: RoutineHomeListener?
    
    private let dependency : RoutineHomeInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    private var list : [RoutineListDto] = []
    
    init(
        presenter: RoutineHomePresentable,
        dependency: RoutineHomeInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        super.init(presenter: presenter)
        
        presenter.listener = self
        self.presentationDelegateProxy.delegate = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
    
        Log.v("Home DidBecome Active💪")
        
        router?.attachRoutineList()
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
            
    // MARK: CreateRoutine
    func createRoutineDidTap() {
        router?.attachCreateRoutine()
    }
    
    func presentationControllerDidDismiss() {
        router?.detachCreateRoutine()
    }
    
    // MARK: RoutineList
    func routineListDidTapRoutineDetail(routineId: UUID) {
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.routineRepository.fetchRoutineDetail(routineId)
                await MainActor.run { [weak self] in
                    self?.router?.attachRoutineDetail(routineId: routineId)
                }
            }catch{
                Log.e("\(error)")
            }
            
        }
    }
    
    // MARK: RoutineDetail
    func routineDetailDidMoved() {
        router?.detachRoutineDetail()
    }
    
}
