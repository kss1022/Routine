//
//  RoutineTopAcheiveChartBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import ModernRIBs

protocol RoutineTopAcheiveChartDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RoutineTopAcheiveChartComponent: Component<RoutineTopAcheiveChartDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RoutineTopAcheiveChartBuildable: Buildable {
    func build(withListener listener: RoutineTopAcheiveChartListener) -> RoutineTopAcheiveChartRouting
}

final class RoutineTopAcheiveChartBuilder: Builder<RoutineTopAcheiveChartDependency>, RoutineTopAcheiveChartBuildable {

    override init(dependency: RoutineTopAcheiveChartDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineTopAcheiveChartListener) -> RoutineTopAcheiveChartRouting {
        let component = RoutineTopAcheiveChartComponent(dependency: dependency)
        let viewController = RoutineTopAcheiveChartViewController()
        let interactor = RoutineTopAcheiveChartInteractor(presenter: viewController)
        interactor.listener = listener
        return RoutineTopAcheiveChartRouter(interactor: interactor, viewController: viewController)
    }
}
