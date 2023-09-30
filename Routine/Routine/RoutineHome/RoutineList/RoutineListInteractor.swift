//
//  RoutineListInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/27.
//

import Foundation
import ModernRIBs

protocol RoutineListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineListPresentable: Presentable {
    var listener: RoutineListPresentableListener? { get set }
    func setRoutineLists(viewModels : [RoutineListViewModel])
}

protocol RoutineListListener: AnyObject {
    func routineListDidTapRoutineDetail(routineId: UUID)
}

protocol RoutineListInteractorDependency{
    var routineReadModel: RoutineReadModelFacade{ get }
}

final class RoutineListInteractor: PresentableInteractor<RoutineListPresentable>, RoutineListInteractable, RoutineListPresentableListener {

    weak var router: RoutineListRouting?
    weak var listener: RoutineListListener?

    private let dependency: RoutineListInteractorDependency

    // in constructor.
    init(
        presenter: RoutineListPresentable,
        dependency: RoutineListInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        do{
            let list = try dependency.routineReadModel.routineList()
            let viewModels = list.map{ list in
                RoutineListViewModel(list) { [weak self] in
                    self?.listener?.routineListDidTapRoutineDetail(routineId: list.routineId)
                } tapCheckButtonHandler: {
                    Log.v("check Button tap \(list.routineName)")
                }
            }
            presenter.setRoutineLists(viewModels: viewModels)
        }catch{
            Log.e("\(error)")
        }
        
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
