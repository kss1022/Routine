//
//  RoutineEditBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/1/23.
//

import Foundation
import ModernRIBs

protocol RoutineEditDependency: Dependency {
    var routineApplicationService: RoutineApplicationService{ get }
    var routineRepository: RoutineRepository{ get }
    var routineRecordRepository: RoutineRecordRepository{ get }
}

final class RoutineEditComponent: Component<RoutineEditDependency> , RoutineEditTitleDependency, RoutineEditStyleDependency, RoutineEditRepeatDependency, RoutineEditReminderDependency, RoutineEditInteractorDependency{
    
    
    let routineId: UUID
    
    var routineApplicationService: RoutineApplicationService{ dependency.routineApplicationService }
    var routineRepository: RoutineRepository{ dependency.routineRepository }
    var routineRecordRepository: RoutineRecordRepository{ dependency.routineRecordRepository }
    
    var detail: RoutineDetailModel?{ routineRepository.detail.value }
        
    
    init(
        dependency: RoutineEditDependency,
        routineId: UUID
    ) {
        self.routineId = routineId
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol RoutineEditBuildable: Buildable {
    func build(withListener listener: RoutineEditListener, routineId : UUID) -> RoutineEditRouting
}

final class RoutineEditBuilder: Builder<RoutineEditDependency>, RoutineEditBuildable {

    override init(dependency: RoutineEditDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineEditListener, routineId: UUID) -> RoutineEditRouting {
        let component = RoutineEditComponent(dependency: dependency, routineId: routineId)
        let viewController = RoutineEditViewController()
        let interactor = RoutineEditInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let routineEditTitleBuilder = RoutineEditTitleBuilder(dependency: component)
        let routineEditStyleBuilder = RoutineEditStyleBuilder(dependency: component)
        let routineEditRepeatBuilder = RoutineEditRepeatBuilder(dependency: component)
        let routineEditReminderBuilder = RoutineEditReminderBuilder(dependency: component)
        
        return RoutineEditRouter(
            interactor: interactor,
            viewController: viewController,
            routineEditTitleBuildable: routineEditTitleBuilder,
            routineEditStyleBuildable: routineEditStyleBuilder,            
            routineEditRepeatBuidlable: routineEditRepeatBuilder,
            routineEditReminderBuildable: routineEditReminderBuilder
        )
    }
}
