//
//  RoutineDetailBuilder.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import Foundation
import ModernRIBs

protocol RoutineDetailDependency: Dependency {
    var routineApplicationService: RoutineApplicationService{ get }
    var routineRepository: RoutineRepository{ get }
}

final class RoutineDetailComponent: Component<RoutineDetailDependency>, RoutineTitleDependency, RoutineEditDependency, RoutineDetailInteractorDependency {
            
    var routineId: UUID
    var routineDetail: ReadOnlyCurrentValuePublisher<RoutineDetailDto?>{ routineRepository.currentRoutineDetail}
    
    var routineApplicationService: RoutineApplicationService{ dependency.routineApplicationService }
    var routineRepository: RoutineRepository{ dependency.routineRepository }
    
    init(dependency: RoutineDetailDependency,routineId: UUID) {
        self.routineId = routineId
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol RoutineDetailBuildable: Buildable {
    func build(withListener listener: RoutineDetailListener, routineId: UUID) -> RoutineDetailRouting
}

final class RoutineDetailBuilder: Builder<RoutineDetailDependency>, RoutineDetailBuildable {

    override init(dependency: RoutineDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineDetailListener, routineId: UUID) -> RoutineDetailRouting {
        let component = RoutineDetailComponent(dependency: dependency, routineId: routineId)
        let viewController = RoutineDetailViewController()
        let interactor = RoutineDetailInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let routineTitleBuilder = RoutineTitleBuilder(dependency: component)
        let routineEditBuilder = RoutineEditBuilder(dependency: component)
        
        return RoutineDetailRouter(
            interactor: interactor,
            viewController: viewController,
            routineEditBuildable: routineEditBuilder,
            routineTitleBuildable: routineTitleBuilder
        )
    }
}
