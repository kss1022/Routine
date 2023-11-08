//
//  RoutineDataBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RoutineDataDependency: Dependency {
    var recordRepository: RecordRepository{ get }
}

final class RoutineDataComponent: Component<RoutineDataDependency>, RoutineDataOfWeekDependency, RoutineDataOfMonthDependency, RoutineDataOfYearDependency, RoutineTotalRecordDependency  {
    var recordRepository: RecordRepository{ dependency.recordRepository }
    
    var routineRecords: ReadOnlyCurrentValuePublisher<RoutineRecordModel?>{ recordRepository.routineRecords }
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
