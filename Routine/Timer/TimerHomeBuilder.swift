//
//  TimerHomeBuilder.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol TimerHomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TimerHomeComponent: Component<TimerHomeDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TimerHomeBuildable: Buildable {
    func build(withListener listener: TimerHomeListener) -> TimerHomeRouting
}

final class TimerHomeBuilder: Builder<TimerHomeDependency>, TimerHomeBuildable {

    override init(dependency: TimerHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerHomeListener) -> TimerHomeRouting {
        let component = TimerHomeComponent(dependency: dependency)
        let viewController = TimerHomeViewController()
        let interactor = TimerHomeInteractor(presenter: viewController)
        interactor.listener = listener
        return TimerHomeRouter(interactor: interactor, viewController: viewController)
    }
}
