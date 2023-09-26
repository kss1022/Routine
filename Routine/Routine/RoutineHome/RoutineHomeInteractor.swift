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
}

protocol RoutineHomePresentable: Presentable {
    var listener: RoutineHomePresentableListener? { get set }
}

protocol RoutineHomeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol RoutineHomeInteractorDependency{
    var routineApplicationService: RoutineApplicationService{ get }
    var routineReadModel: RoutineReadModelFacade{ get }
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
        do{
            let list = try dependency.routineReadModel.routineList()
            Log.v("Read SavedList: \(list)")
        }catch{
            Log.e("Read RoutineList Error: \(error)")
        }
        
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
            
    
    func createRoutineDidTap() {
        router?.attachCreateRoutine()
//        Task{
//            do{
//                try await dependency.routineApplicationService.when(CreateRoutine(
//                    name: "NewRoutine",
//                    description: "Description",
//                    icon: "💪",
//                    tint: "0xff000000",
//                    createCheckLists: [
//                        CreateCheckList(name: "NewCheckList", reps: 3, set: 3, weight: 5.0, sequence: 0)
//                    ]
//                ))
//                let list = try dependency.routineReadModel.routineList()
//                Log.v("Read SavedList: \(list)")
//            }catch{
//                if let error = error as? ArgumentException{
//                    Log.e(error.msg)
//                }else{
//                    Log.e("UnkownError\n\(error)" )
//                }
//            }
//        }
//        
    }
    
    func presentationControllerDidDismiss() {
        router?.detachCreateRoutine()
    }
    
    
    
}
