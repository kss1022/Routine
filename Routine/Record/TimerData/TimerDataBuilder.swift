//
//  TimerDataBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import Foundation
import ModernRIBs

protocol TimerDataDependency: Dependency {
    var timerRecordRepository: TimerRecordRepository{ get }
}

final class TimerDataComponent: Component<TimerDataDependency>, TimerDataOfYearDependency, TimerDataOfStatsDependency, TimerTotalRecordDependency, TimerDataInteractorDependency {
    
    var timerRecordRepository: TimerRecordRepository{ dependency.timerRecordRepository }
    
    var timerRecords: ReadOnlyCurrentValuePublisher<[TimerRecordModel]>{ timerRecordsSubject}
    let timerRecordsSubject = CurrentValuePublisher<[TimerRecordModel]>([])
        
    var timerMonthRecords: ReadOnlyCurrentValuePublisher<[TimerMonthRecordModel]>{ timerMonthRecordsSubject }
    let timerMonthRecordsSubject = CurrentValuePublisher<[TimerMonthRecordModel]>([])
    
    var timerWeekRecords: ReadOnlyCurrentValuePublisher<[TimerWeekRecordModel]>{ timerWeekRecordsSubject }
    let timerWeekRecordsSubject = CurrentValuePublisher<[TimerWeekRecordModel]>([])
    
    var timerSummeryModel: ReadOnlyCurrentValuePublisher<TimerSummeryModel?>{ timerSummeryModelSubject }
    let timerSummeryModelSubject = CurrentValuePublisher<TimerSummeryModel?>(nil)
}

// MARK: - Builder

protocol TimerDataBuildable: Buildable {
    func build(withListener listener: TimerDataListener, timerId: UUID) -> TimerDataRouting
}

final class TimerDataBuilder: Builder<TimerDataDependency>, TimerDataBuildable {

    override init(dependency: TimerDataDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerDataListener, timerId: UUID) -> TimerDataRouting {
        let component = TimerDataComponent(dependency: dependency)
        let viewController = TimerDataViewController()
        let interactor = TimerDataInteractor(presenter: viewController, dependency: component, timerId: timerId)
        interactor.listener = listener
        
        let timerDataOfYearBuilder = TimerDataOfYearBuilder(dependency: component)
        let timerDataOfStasBuilder = TimerDataOfStatsBuilder(dependency: component)
        let timerTotalRecordBuilder = TimerTotalRecordBuilder(dependency: component)
        
        return TimerDataRouter(
            interactor: interactor,
            viewController: viewController,
            timerDataOfYearBuildable: timerDataOfYearBuilder,
            timerDataOfStatsBuildable: timerDataOfStasBuilder,
            timerTotalRecordBuildable: timerTotalRecordBuilder
        )
    }
}
