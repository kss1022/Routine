//
//  TimerSectionEditValueBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs

protocol TimerSectionEditValueDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TimerSectionEditValueComponent: Component<TimerSectionEditValueDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TimerSectionEditValueBuildable: Buildable {
    func build(withListener listener: TimerSectionEditValueListener) -> TimerSectionEditValueRouting
}

final class TimerSectionEditValueBuilder: Builder<TimerSectionEditValueDependency>, TimerSectionEditValueBuildable {

    override init(dependency: TimerSectionEditValueDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerSectionEditValueListener) -> TimerSectionEditValueRouting {
        let component = TimerSectionEditValueComponent(dependency: dependency)
        let viewController = TimerSectionEditValueViewController()
        let interactor = TimerSectionEditValueInteractor(presenter: viewController)
        interactor.listener = listener
        return TimerSectionEditValueRouter(interactor: interactor, viewController: viewController)
    }
}
