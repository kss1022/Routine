//
//  RoutineDataBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RoutineDataDependency: Dependency {
    var routineRecordRepository: RoutineRecordRepository{ get }
}

final class RoutineDataComponent: Component<RoutineDataDependency>, RoutineDataOfWeekDependency, RoutineDataOfMonthDependency, RoutineDataOfYearDependency, RoutineTotalRecordDependency  {
    var routineRecordRepository: RoutineRecordRepository{ dependency.routineRecordRepository }
    
    var routineRecords: ReadOnlyCurrentValuePublisher<RoutineRecordDatasModel?>{ routineRecordRepository.records }
}

// MARK: - Builder

protocol RoutineDataBuildable: Buildable {
    func build(withListener listener: RoutineDataListener) -> RoutineDataRouting
}

final class RoutineDataBuilder: Builder<RoutineDataDependency>, RoutineDataBuildable {

    override init(dependency: RoutineDataDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineDataListener) -> RoutineDataRouting {
        let component = RoutineDataComponent(dependency: dependency)
        let viewController = RoutineDataViewController()
        let interactor = RoutineDataInteractor(presenter: viewController)
        interactor.listener = listener
        
        let routineDataOfWeekBuilder = RoutineDataOfWeekBuilder(dependency: component)
        let routineDataOfMonthBuilder = RoutineDataOfMonthBuilder(dependency: component)
        let routineDataOfYearBuilder = RoutineDataOfYearBuilder(dependency: component)
        let routineTotalRecordBuilder = RoutineTotalRecordBuilder(dependency: component)
        
        return RoutineDataRouter(
            interactor: interactor,
            viewController: viewController,
            routineDataOfWeekBuildable: routineDataOfWeekBuilder,
            routineDataOfMonthBuildable: routineDataOfMonthBuilder,
            routineDataOfYearBuildable: routineDataOfYearBuilder,
            routineTotalRecordBuildable: routineTotalRecordBuilder
        )
    }
}
