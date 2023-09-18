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
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RoutineHomeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol RoutineHomeInteractorDependency{
    var routineApplicationService: RoutineApplicationService{ get }
}

final class RoutineHomeInteractor: PresentableInteractor<RoutineHomePresentable>, RoutineHomeInteractable, RoutineHomePresentableListener {

    weak var router: RoutineHomeRouting?
    weak var listener: RoutineHomeListener?

    private let dependency : RoutineHomeInteractorDependency
    private var cancellables: Set<AnyCancellable>


    
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
        
        
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    
    
    func createRoutineDidTap() {
        Task{
            do{
                try await dependency.routineApplicationService.when(CreateRoutine(name: "생성이 되주세요 제발 ㅜㅜㅜㅜ"))
            }catch{
                if let error = error as? ArgumentException{
                    print(error.msg)
                }else{
                    print("UnkownError\n\(error)" )
                }
            }
        }
        
    }
}



class MyDomainEvent : Event{
    let id = 10
}
