//
//  RoutineWeekCalenderBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/5/23.
//

import ModernRIBs

protocol RoutineWeekCalenderDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RoutineWeekCalenderComponent: Component<RoutineWeekCalenderDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RoutineWeekCalenderBuildable: Buildable {
    func build(withListener listener: RoutineWeekCalenderListener) -> RoutineWeekCalenderRouting
}

final class RoutineWeekCalenderBuilder: Builder<RoutineWeekCalenderDependency>, RoutineWeekCalenderBuildable {

    override init(dependency: RoutineWeekCalenderDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineWeekCalenderListener) -> RoutineWeekCalenderRouting {
        let component = RoutineWeekCalenderComponent(dependency: dependency)
        let viewController = RoutineWeekCalenderViewController()
        let interactor = RoutineWeekCalenderInteractor(presenter: viewController)
        interactor.listener = listener
        return RoutineWeekCalenderRouter(interactor: interactor, viewController: viewController)
    }
}
