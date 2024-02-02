//
//  TimerSectionEditRepeatBuilder.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import ModernRIBs

protocol TimerSectionEditRepeatDependency: Dependency {
}

final class TimerSectionEditRepeatComponent: Component<TimerSectionEditRepeatDependency> {
}

// MARK: - Builder

protocol TimerSectionEditRepeatBuildable: Buildable {
    func build(withListener listener: TimerSectionEditRepeatListener, repeat: Int) -> TimerSectionEditRepeatRouting
}

final class TimerSectionEditRepeatBuilder: Builder<TimerSectionEditRepeatDependency>, TimerSectionEditRepeatBuildable {

    override init(dependency: TimerSectionEditRepeatDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerSectionEditRepeatListener, repeat: Int) -> TimerSectionEditRepeatRouting {
        let component = TimerSectionEditRepeatComponent(dependency: dependency)
        let viewController = TimerSectionEditRepeatViewController()
        let interactor = TimerSectionEditRepeatInteractor(presenter: viewController, repeat: `repeat`)
        interactor.listener = listener
        return TimerSectionEditRepeatRouter(interactor: interactor, viewController: viewController)
    }
}
