//
//  RoutineWeekCalendarBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/5/23.
//

import ModernRIBs

protocol RoutineWeekCalendarDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RoutineWeekCalendarComponent: Component<RoutineWeekCalendarDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RoutineWeekCalendarBuildable: Buildable {
    func build(withListener listener: RoutineWeekCalendarListener) -> RoutineWeekCalendarRouting
}

final class RoutineWeekCalendarBuilder: Builder<RoutineWeekCalendarDependency>, RoutineWeekCalendarBuildable {

    override init(dependency: RoutineWeekCalendarDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineWeekCalendarListener) -> RoutineWeekCalendarRouting {
        let component = RoutineWeekCalendarComponent(dependency: dependency)
        let viewController = RoutineWeekCalendarViewController()
        let interactor = RoutineWeekCalendarInteractor(presenter: viewController)
        interactor.listener = listener
        return RoutineWeekCalendarRouter(interactor: interactor, viewController: viewController)
    }
}
