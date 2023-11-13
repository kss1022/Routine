//
//  RoutineWeeklyTableBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol RoutineWeeklyTableDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RoutineWeeklyTableComponent: Component<RoutineWeeklyTableDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
        let interactor = RoutineWeeklyTableInteractor(presenter: viewController)
        interactor.listener = listener
        return RoutineWeeklyTableRouter(interactor: interactor, viewController: viewController)
    }
}
