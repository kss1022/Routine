//
//  TimerTotalRecordBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol TimerTotalRecordDependency: Dependency {
    var timerSummeryModel: ReadOnlyCurrentValuePublisher<TimerSummeryModel?>{ get }
}

final class TimerTotalRecordComponent: Component<TimerTotalRecordDependency>, TimerTotalRecordInteractorDependency {
    var timerSummeryModel: ReadOnlyCurrentValuePublisher<TimerSummeryModel?>{ dependency.timerSummeryModel }
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
        let interactor = TimerTotalRecordInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return TimerTotalRecordRouter(interactor: interactor, viewController: viewController)
    }
}
