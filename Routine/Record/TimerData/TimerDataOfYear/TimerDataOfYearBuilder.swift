//
//  TimerDataOfYearBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol TimerDataOfYearDependency: Dependency {
    var timerRecords: ReadOnlyCurrentValuePublisher<[TimerRecordModel]>{ get }
}

final class TimerDataOfYearComponent: Component<TimerDataOfYearDependency>, TimerDataOfYearInteractorDependency {
    var timerRecords: ReadOnlyCurrentValuePublisher<[TimerRecordModel]>{ dependency.timerRecords }
}

// MARK: - Builder

protocol TimerDataOfYearBuildable: Buildable {
    func build(withListener listener: TimerDataOfYearListener) -> TimerDataOfYearRouting
}

final class TimerDataOfYearBuilder: Builder<TimerDataOfYearDependency>, TimerDataOfYearBuildable {

    override init(dependency: TimerDataOfYearDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerDataOfYearListener) -> TimerDataOfYearRouting {
        let component = TimerDataOfYearComponent(dependency: dependency)
        let viewController = TimerDataOfYearViewController()
        let interactor = TimerDataOfYearInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return TimerDataOfYearRouter(interactor: interactor, viewController: viewController)
    }
}
