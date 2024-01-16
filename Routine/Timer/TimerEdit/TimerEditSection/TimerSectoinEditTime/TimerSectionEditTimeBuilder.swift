//
//  TimerSectionEditTimeBuilder.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import ModernRIBs

protocol TimerSectionEditTimeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TimerSectionEditTimeComponent: Component<TimerSectionEditTimeDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TimerSectionEditTimeBuildable: Buildable {
    func build(withListener listener: TimerSectionEditTimeListener, min: Int, sec: Int) -> TimerSectionEditTimeRouting
}

final class TimerSectionEditTimeBuilder: Builder<TimerSectionEditTimeDependency>, TimerSectionEditTimeBuildable {

    override init(dependency: TimerSectionEditTimeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerSectionEditTimeListener, min: Int, sec: Int) -> TimerSectionEditTimeRouting {
        let component = TimerSectionEditTimeComponent(dependency: dependency)
        let viewController = TimerSectionEditTimeViewController()
        let interactor = TimerSectionEditTimeInteractor(presenter: viewController, min: min, sec: sec)
        interactor.listener = listener
        return TimerSectionEditTimeRouter(interactor: interactor, viewController: viewController)
    }
}
