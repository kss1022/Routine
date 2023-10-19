//
//  TimerListBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol TimerListDependency: Dependency {
    var timerRepository: TimerRepository{ get }
}

final class TimerListComponent: Component<TimerListDependency>, TimerListInteractorDependency {
    var timerRepository: TimerRepository{ dependency.timerRepository }
}

// MARK: - Builder

protocol TimerListBuildable: Buildable {
    func build(withListener listener: TimerListListener) -> TimerListRouting
}

final class TimerListBuilder: Builder<TimerListDependency>, TimerListBuildable {

    override init(dependency: TimerListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerListListener) -> TimerListRouting {
        let component = TimerListComponent(dependency: dependency)
        let viewController = TimerListViewController()
        let interactor = TimerListInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return TimerListRouter(interactor: interactor, viewController: viewController)
    }
}
