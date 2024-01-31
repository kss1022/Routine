//
//  TimerDataOfStatsBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol TimerDataOfStatsDependency: Dependency {
    var timerRecords: ReadOnlyCurrentValuePublisher<[TimerRecordModel]>{ get }
    var timerMonthRecords: ReadOnlyCurrentValuePublisher<[TimerMonthRecordModel]>{ get }
    var timerWeekRecords: ReadOnlyCurrentValuePublisher<[TimerWeekRecordModel]>{ get }
}

final class TimerDataOfStatsComponent: Component<TimerDataOfStatsDependency>, TimerDataOfStatsInteractorDependency {
    var timerRecords: ReadOnlyCurrentValuePublisher<[TimerRecordModel]>{ dependency.timerRecords }
    var timerMonthRecords: ReadOnlyCurrentValuePublisher<[TimerMonthRecordModel]>{ dependency.timerMonthRecords }
    var timerWeekRecords: ReadOnlyCurrentValuePublisher<[TimerWeekRecordModel]>{ dependency.timerWeekRecords }
}

// MARK: - Builder

protocol TimerDataOfStatsBuildable: Buildable {
    func build(withListener listener: TimerDataOfStatsListener) -> TimerDataOfStatsRouting
}

final class TimerDataOfStatsBuilder: Builder<TimerDataOfStatsDependency>, TimerDataOfStatsBuildable {

    override init(dependency: TimerDataOfStatsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerDataOfStatsListener) -> TimerDataOfStatsRouting {
        let component = TimerDataOfStatsComponent(dependency: dependency)
        let viewController = TimerDataOfStatsViewController()
        let interactor = TimerDataOfStatsInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return TimerDataOfStatsRouter(interactor: interactor, viewController: viewController)
    }
}
