//
//  RoutineWeeklyTrackerBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol RoutineWeeklyTrackerDependency: Dependency {
    var routineRecordRepository: RoutineRecordRepository{ get }
}

final class RoutineWeeklyTrackerComponent: Component<RoutineWeeklyTrackerDependency>, RoutineWeeklyTableDependency {
    var routineRecordRepository: RoutineRecordRepository{ dependency.routineRecordRepository }
    
    var routines: ReadOnlyCurrentValuePublisher<[RecordRoutineListModel]>{ routineRecordRepository.lists }
    var routineWeeks: ReadOnlyCurrentValuePublisher<[RoutineWeekRecordModel]>{ routineRecordRepository.weeks }
}

// MARK: - Builder

protocol RoutineWeeklyTrackerBuildable: Buildable {
    func build(withListener listener: RoutineWeeklyTrackerListener) -> RoutineWeeklyTrackerRouting
}

final class RoutineWeeklyTrackerBuilder: Builder<RoutineWeeklyTrackerDependency>, RoutineWeeklyTrackerBuildable {

    override init(dependency: RoutineWeeklyTrackerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineWeeklyTrackerListener) -> RoutineWeeklyTrackerRouting {
        let component = RoutineWeeklyTrackerComponent(dependency: dependency)
        let viewController = RoutineWeeklyTrackerViewController()
        let interactor = RoutineWeeklyTrackerInteractor(presenter: viewController)
        interactor.listener = listener
        
        let routineWeeklyTableBuilder = RoutineWeeklyTableBuilder(dependency: component)
        
        return RoutineWeeklyTrackerRouter(
            interactor: interactor,
            viewController: viewController,
            routineWeeklyTableBuildable: routineWeeklyTableBuilder
        )
    }
}
