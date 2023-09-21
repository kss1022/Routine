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
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
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

final class RoutineHomeInteractor: PresentableInteractor<RoutineHomePresentable>, RoutineHomeInteractable, RoutineHomePresentableListener {
    
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
        
        super.init(presenter: presenter)
        presenter.listener = self
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
        Task{
            do{
                try await dependency.routineApplicationService.when(CreateRoutine(name: "create New Routine"))
                let list = try dependency.routineReadModel.routineList()
                Log.v("Read SavedList: \(list)")
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.msg)
                }else{
                    Log.e("UnkownError\n\(error)" )
                }
            }
        }
        
    }
    
    func updateButtonDidTap(text: String) {
        Task{
            do{
                guard let routine = try dependency.routineReadModel.routineList().first else {
                    Log.e("Update RoutineName Fail: Can not find Routine")
                    return
                }
                
                try await dependency.routineApplicationService.when(ChangeRoutineName(
                    routineId: routine.routineId,
                    routineName: text
                ))
                
                if let detail = try dependency.routineReadModel.routineDetail(id: routine.routineId){
                    Log.v("Chanage RoutineName: \(detail)")
                }
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.msg)
                }else{
                    Log.e("UnkownError\n\(error)" )
                }
            }
            
        }
    }
    
    func readButtonDidTap() {
        do{
            let list = try dependency.routineReadModel.routineList()
            Log.v("Read SavedList: \(list)")
        }catch{
            Log.e("Read RoutineList Error : \(error)")
        }
    }
}
