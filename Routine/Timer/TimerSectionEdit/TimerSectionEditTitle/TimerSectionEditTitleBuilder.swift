//
//  TimerSectionEditTitleBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol TimerSectionEditTitleDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TimerSectionEditTitleComponent: Component<TimerSectionEditTitleDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TimerSectionEditTitleBuildable: Buildable {
    func build(withListener listener: TimerSectionEditTitleListener) -> TimerSectionEditTitleRouting
}

final class TimerSectionEditTitleBuilder: Builder<TimerSectionEditTitleDependency>, TimerSectionEditTitleBuildable {

    override init(dependency: TimerSectionEditTitleDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerSectionEditTitleListener) -> TimerSectionEditTitleRouting {
        let component = TimerSectionEditTitleComponent(dependency: dependency)
        let viewController = TimerSectionEditTitleViewController()
        let interactor = TimerSectionEditTitleInteractor(presenter: viewController)
        interactor.listener = listener
        return TimerSectionEditTitleRouter(interactor: interactor, viewController: viewController)
    }
}
