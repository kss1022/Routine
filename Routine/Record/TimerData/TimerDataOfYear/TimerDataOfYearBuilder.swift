//
//  TimerDataOfYearBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol TimerDataOfYearDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TimerDataOfYearComponent: Component<TimerDataOfYearDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TimerDataOfYearBuildable: Buildable {
    func build(withListener listener: TimerDataOfYearListener) -> TimerDataOfYearRouting
}

final class TimerDataOfYearBuilder: Builder<TimerDataOfYearDependency>, TimerDataOfYearBuildable {

    override init(dependency: TimerDataOfYearDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerDataOfYearListener) -> TimerDataOfYearRouting {
        let component = TimerDataOfYearComponent(dependency: dependency)
        let viewController = TimerDataOfYearViewController()
        let interactor = TimerDataOfYearInteractor(presenter: viewController)
        interactor.listener = listener
        return TimerDataOfYearRouter(interactor: interactor, viewController: viewController)
    }
}
