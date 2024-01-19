//
//  RecordHomeBuilder.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol RecordHomeDependency: Dependency {
    var recordApplicationService: RecordApplicationService{ get }
    
    var routineRecordRepository: RoutineRecordRepository{ get }
    var routineRepository: RoutineRepository{ get }
}

final class RecordHomeComponent: Component<RecordHomeDependency>,RoutineTopAcheiveDependency, RoutineWeeklyTrackerDependency, RecordRoutineListDetailDependency, RecordTimerListDetailDependency, RoutineDataDependency, TimerDataDependency ,RecordBannerDependency, RecordRoutineListDependency, RecordTimerListDependency, RecordHomeInteractorDependency {
    var recordApplicationService: RecordApplicationService{ dependency.recordApplicationService }
    
    var routineRecordRepository: RoutineRecordRepository{ dependency.routineRecordRepository }
    var routineRepository: RoutineRepository{ dependency.routineRepository }
}

// MARK: - Builder

protocol RecordHomeBuildable: Buildable {
    func build(withListener listener: RecordHomeListener) -> RecordHomeRouting
}

final class RecordHomeBuilder: Builder<RecordHomeDependency>, RecordHomeBuildable {

    override init(dependency: RecordHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RecordHomeListener) -> RecordHomeRouting {
        let component = RecordHomeComponent(dependency: dependency)
        let viewController = RecordHomeViewController()
        let interactor = RecordHomeInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let routineTopAcheiveBuilder = RoutineTopAcheiveBuilder(dependency: component)
        let routineWeeklyTrackerBuilder = RoutineWeeklyTrackerBuilder(dependency: component)
        
        let recordRoutineListDetailBuilder = RecordRoutineListDetailBuilder(dependency: component)
        let recordTimerListDetailBuilder = RecordTimerListDetailBuilder(dependency: component)
        
        let routineDataBuilder = RoutineDataBuilder(dependency: component)
        let timerDataBuilder = TimerDataBuilder(dependency: component)
        
        let recordBannerBuilder = RecordBannerBuilder(dependency: component)
        let recordRoutineListBuilder = RecordRoutineListBuilder(dependency: component)
        let recrodTimerListBuilder = RecordTimerListBuilder(dependency: component)
        
        return RecordHomeRouter(
            interactor: interactor,
            viewController: viewController, 
            routineTopAcheiveBuildable: routineTopAcheiveBuilder,
            routineWeeklyTrackerBuildable: routineWeeklyTrackerBuilder,
            recordRoutineListDetailBuildable: recordRoutineListDetailBuilder,
            recordTimerListDetailBuildable: recordTimerListDetailBuilder,
            routineDataBuildable: routineDataBuilder,
            timerDataBuildable: timerDataBuilder,
            recordBannerBuildable: recordBannerBuilder,
            recordRoutineListBuildable: recordRoutineListBuilder,
            recordTimerListBuildable: recrodTimerListBuilder
        )
    }
}
