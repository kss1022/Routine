//
//  TimerTotalRecordBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol TimerTotalRecordDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TimerTotalRecordComponent: Component<TimerTotalRecordDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TimerTotalRecordBuildable: Buildable {
    func build(withListener listener: TimerTotalRecordListener) -> TimerTotalRecordRouting
}

final class TimerTotalRecordBuilder: Builder<TimerTotalRecordDependency>, TimerTotalRecordBuildable {

    override init(dependency: TimerTotalRecordDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerTotalRecordListener) -> TimerTotalRecordRouting {
        let component = TimerTotalRecordComponent(dependency: dependency)
        let viewController = TimerTotalRecordViewController()
        let interactor = TimerTotalRecordInteractor(presenter: viewController)
        interactor.listener = listener
        return TimerTotalRecordRouter(interactor: interactor, viewController: viewController)
    }
}
