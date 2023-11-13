//
//  TimerDataOfStatsBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol TimerDataOfStatsDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TimerDataOfStatsComponent: Component<TimerDataOfStatsDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TimerDataOfStatsBuildable: Buildable {
    func build(withListener listener: TimerDataOfStatsListener) -> TimerDataOfStatsRouting
}

final class TimerDataOfStatsBuilder: Builder<TimerDataOfStatsDependency>, TimerDataOfStatsBuildable {

    override init(dependency: TimerDataOfStatsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerDataOfStatsListener) -> TimerDataOfStatsRouting {
        let component = TimerDataOfStatsComponent(dependency: dependency)
        let viewController = TimerDataOfStatsViewController()
        let interactor = TimerDataOfStatsInteractor(presenter: viewController)
        interactor.listener = listener
        return TimerDataOfStatsRouter(interactor: interactor, viewController: viewController)
    }
}
