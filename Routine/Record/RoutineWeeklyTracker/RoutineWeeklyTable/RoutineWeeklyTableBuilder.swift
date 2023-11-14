//
//  RoutineWeeklyTableBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol RoutineWeeklyTableDependency: Dependency {
    var routineWeeklyTrackers: ReadOnlyCurrentValuePublisher<[RoutineWeeklyTrackerModel]>{ get }
}

final class RoutineWeeklyTableComponent: Component<RoutineWeeklyTableDependency>, RoutineWeeklyTableInteractorDependency {
    var routineWeeklyTrackers: ReadOnlyCurrentValuePublisher<[RoutineWeeklyTrackerModel]>{ dependency.routineWeeklyTrackers }
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
