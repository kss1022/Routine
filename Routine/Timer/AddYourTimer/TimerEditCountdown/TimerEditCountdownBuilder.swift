//
//  TimerEditCountdownBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/31/23.
//

import ModernRIBs

protocol TimerEditCountdownDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TimerEditCountdownComponent: Component<TimerEditCountdownDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TimerEditCountdownBuildable: Buildable {
    func build(withListener listener: TimerEditCountdownListener) -> TimerEditCountdownRouting
}

final class TimerEditCountdownBuilder: Builder<TimerEditCountdownDependency>, TimerEditCountdownBuildable {

    override init(dependency: TimerEditCountdownDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerEditCountdownListener) -> TimerEditCountdownRouting {
        let component = TimerEditCountdownComponent(dependency: dependency)
        let viewController = TimerEditCountdownViewController()
        let interactor = TimerEditCountdownInteractor(presenter: viewController)
        interactor.listener = listener
        return TimerEditCountdownRouter(interactor: interactor, viewController: viewController)
    }
}
