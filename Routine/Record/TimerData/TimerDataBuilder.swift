//
//  TimerDataBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol TimerDataDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TimerDataComponent: Component<TimerDataDependency>, TimerDataOfYearDependency, TimerDataOfStatsDependency, TimerTotalRecordDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TimerDataBuildable: Buildable {
    func build(withListener listener: TimerDataListener) -> TimerDataRouting
}

final class TimerDataBuilder: Builder<TimerDataDependency>, TimerDataBuildable {

    override init(dependency: TimerDataDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerDataListener) -> TimerDataRouting {
        let component = TimerDataComponent(dependency: dependency)
        let viewController = TimerDataViewController()
        let interactor = TimerDataInteractor(presenter: viewController)
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
