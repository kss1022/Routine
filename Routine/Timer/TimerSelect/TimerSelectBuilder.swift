//
//  TimerSelectBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/26/23.
//

import ModernRIBs

protocol TimerSelectDependency: Dependency {
    var timerRepository: TimerRepository{ get }
}

final class TimerSelectComponent: Component<TimerSelectDependency>, TimerSelectInteractorDependency {
    var timerRepository: TimerRepository{ dependency.timerRepository }
}

// MARK: - Builder

protocol TimerSelectBuildable: Buildable {
    func build(withListener listener: TimerSelectListener) -> TimerSelectRouting
}

final class TimerSelectBuilder: Builder<TimerSelectDependency>, TimerSelectBuildable {

    override init(dependency: TimerSelectDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerSelectListener) -> TimerSelectRouting {
        let component = TimerSelectComponent(dependency: dependency)
        let viewController = TimerSelectViewController()
        let interactor = TimerSelectInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return TimerSelectRouter(interactor: interactor, viewController: viewController)
    }
}
