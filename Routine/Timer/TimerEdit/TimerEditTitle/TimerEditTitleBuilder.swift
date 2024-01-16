//
//  TimerEditTitleBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import ModernRIBs

protocol TimerEditTitleDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TimerEditTitleComponent: Component<TimerEditTitleDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TimerEditTitleBuildable: Buildable {
    func build(withListener listener: TimerEditTitleListener, name: String, emoji: String) -> TimerEditTitleRouting
}

final class TimerEditTitleBuilder: Builder<TimerEditTitleDependency>, TimerEditTitleBuildable {

    override init(dependency: TimerEditTitleDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerEditTitleListener, name: String, emoji: String) -> TimerEditTitleRouting {
        let component = TimerEditTitleComponent(dependency: dependency)
        let viewController = TimerEditTitleViewController()
        let interactor = TimerEditTitleInteractor(presenter: viewController, name: name, emoji: emoji)
        interactor.listener = listener
        return TimerEditTitleRouter(interactor: interactor, viewController: viewController)
    }
}
