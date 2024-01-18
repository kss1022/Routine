//
//  TimerNextSectionBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs

protocol TimerNextSectionDependency: Dependency {
    var nextSection: ReadOnlyCurrentValuePublisher<TimeSectionModel?>{ get }
}

final class TimerNextSectionComponent: Component<TimerNextSectionDependency>, TimerNextSectionInteractorDependency {
    var nextSection: ReadOnlyCurrentValuePublisher<TimeSectionModel?>{ dependency.nextSection }
}

// MARK: - Builder

protocol TimerNextSectionBuildable: Buildable {
    func build(withListener listener: TimerNextSectionListener) -> TimerNextSectionRouting
}

final class TimerNextSectionBuilder: Builder<TimerNextSectionDependency>, TimerNextSectionBuildable {

    override init(dependency: TimerNextSectionDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerNextSectionListener) -> TimerNextSectionRouting {
        let component = TimerNextSectionComponent(dependency: dependency)
        let viewController = TimerNextSectionViewController()
        let interactor = TimerNextSectionInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return TimerNextSectionRouter(interactor: interactor, viewController: viewController)
    }
}
