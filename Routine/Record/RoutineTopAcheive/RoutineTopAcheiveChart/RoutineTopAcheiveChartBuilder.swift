//
//  RoutineTopAcheiveChartBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import ModernRIBs

protocol RoutineTopAcheiveChartDependency: Dependency {
    var topAcheives: ReadOnlyCurrentValuePublisher<[RoutineTopAcheiveModel]>{ get }
}

final class RoutineTopAcheiveChartComponent: Component<RoutineTopAcheiveChartDependency>, RoutineTopAcheiveChartInteractorDependency {
    var topAcheives: ReadOnlyCurrentValuePublisher<[RoutineTopAcheiveModel]>{ dependency.topAcheives }
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
        let interactor = RoutineTopAcheiveChartInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return RoutineTopAcheiveChartRouter(interactor: interactor, viewController: viewController)
    }
}
