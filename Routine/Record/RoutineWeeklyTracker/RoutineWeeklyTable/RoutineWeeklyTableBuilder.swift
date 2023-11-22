//
//  RoutineWeeklyTableBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol RoutineWeeklyTableDependency: Dependency {
    var routines: ReadOnlyCurrentValuePublisher<[RecordRoutineListModel]>{ get }
    var routineWeeks: ReadOnlyCurrentValuePublisher<[RoutineWeekRecordModel]>{ get }
}

final class RoutineWeeklyTableComponent: Component<RoutineWeeklyTableDependency>, RoutineWeeklyTableInteractorDependency {
    var routines: ReadOnlyCurrentValuePublisher<[RecordRoutineListModel]>{ dependency.routines }
    var routineWeeks: ReadOnlyCurrentValuePublisher<[RoutineWeekRecordModel]>{ dependency.routineWeeks }
}

// MARK: - Builder

protocol RoutineWeeklyTableBuildable: Buildable {
    func build(withListener listener: RoutineWeeklyTableListener) -> RoutineWeeklyTableRouting
}

final class RoutineWeeklyTableBuilder: Builder<RoutineWeeklyTableDependency>, RoutineWeeklyTableBuildable {

    override init(dependency: RoutineWeeklyTableDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineWeeklyTableListener) -> RoutineWeeklyTableRouting {
        let component = RoutineWeeklyTableComponent(dependency: dependency)
        let viewController = RoutineWeeklyTableViewController()
        let interactor = RoutineWeeklyTableInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return RoutineWeeklyTableRouter(interactor: interactor, viewController: viewController)
    }
}
