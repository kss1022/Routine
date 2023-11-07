//
//  RoutineDataOfYearBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RoutineDataOfYearDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RoutineDataOfYearComponent: Component<RoutineDataOfYearDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RoutineDataOfYearBuildable: Buildable {
    func build(withListener listener: RoutineDataOfYearListener) -> RoutineDataOfYearRouting
}

final class RoutineDataOfYearBuilder: Builder<RoutineDataOfYearDependency>, RoutineDataOfYearBuildable {

    override init(dependency: RoutineDataOfYearDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineDataOfYearListener) -> RoutineDataOfYearRouting {
        let component = RoutineDataOfYearComponent(dependency: dependency)
        let viewController = RoutineDataOfYearViewController()
        let interactor = RoutineDataOfYearInteractor(presenter: viewController)
        interactor.listener = listener
        return RoutineDataOfYearRouter(interactor: interactor, viewController: viewController)
    }
}
