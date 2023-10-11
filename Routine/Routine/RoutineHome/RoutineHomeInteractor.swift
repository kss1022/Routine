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
    func detachCreateRoutine(dismiss: Bool)
    
    func attachRoutineDetail(routineId: UUID)
    func detachRoutineDetail(dismiss: Bool)
    
    func attachRoutineWeekCalender()
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
    private var presentationType : RoutineHomePresentationType
    
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
        presentationType  = .none
        super.init(presenter: presenter)
        
        presenter.listener = self
        self.presentationDelegateProxy.delegate = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        Log.v("Home DidBecome Active💪")
        router?.attachRoutineWeekCalender()
        router?.attachRoutineList()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
        
    
    func presentationControllerDidDismiss() {
        switch presentationType {
        case .none: break
        case .create:
            router?.detachCreateRoutine(dismiss: false)
        case .detail:
            router?.detachRoutineDetail(dismiss: false)
        }
        
        presentationType = .none
    }
    
    //MARK: RoutineWeekCalender
    func routineWeekCalenderDidTap(date: Date) {
        Task{ [weak self] in
            await self?.dependency.routineRepository.fetchHomeList(date: date)
        }
    }
    

            
    // MARK: CreateRoutine
    func createRoutineBarButtonDidTap() {
        presentationType = .create
        router?.attachCreateRoutine()
    }

    func createRoutineDismiss() {
        presentationType = .none
        router?.detachCreateRoutine(dismiss: true)
    }
        
    
    // MARK: RoutineDetail
    func routineListDidTapRoutineDetail(routineId: UUID) {
        if presentationType == .detail{
            return
        }
        
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.routineRepository.fetchDetail(routineId)
                await MainActor.run { [weak self] in
                    self?.presentationType = .detail
                    self?.router?.attachRoutineDetail(routineId: routineId)
                }
            }catch{
                Log.e("\(error)")
            }
            
        }
    }
    
    func routineDetailDismiss() {
        presentationType = .none
        self.router?.detachRoutineDetail(dismiss: true)
    }
    

    
    private enum RoutineHomePresentationType{
        case none
        case create
        case detail
    }
    
}
