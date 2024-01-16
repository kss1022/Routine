//
//  AppRootComponent.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation
import ModernRIBs


final class AppRootComponent: Component<AppRootDependency> , AppHomeDependency, AppTutorialDependency, AppRootInteractorDependency,  CreateRoutineDependency{
    
    //MARK: ApplicationService
    let routineApplicationService: RoutineApplicationService
    let recordApplicationService: RecordApplicationService
    let timerApplicationService: TimerApplicationService
    let profileApplicationService: ProfileApplicationService
    
    //MARK: ReadModel
    private let routineReadModel: RoutineReadModelFacade
    private let repeatReadModel: RepeatReadModelFacade
    private let reminderReadModel: ReminderReadModelFacade
    
    private let timerReadModel: TimerReadModelFacade
    
    private let routineRecordReadModel: RoutineRecordReadModelFacade
    private let timerRecordReadModel: TimerRecordReadModelFacade
    
    private let profileReadModel: ProfileReadModelFacade
    
    
    //MAKR: Projection
    private let routineProjection: RoutineProjection
    private let reminderProjection: ReminderProjection
    private let recordProjection: RecordProjection
    private let timerProjection: TimerProjection
    private let profileProjection: ProfileProjection
    
    //MARK: Repository
    let routineRepository: RoutineRepository
    let timerRepository: TimerRepository
    let recordRepository: RecordRepository
    let profileRepository: ProfileRepository
    let reminderRepository: ReminderRepository
    
    
    
    lazy var createRoutineBuildable: CreateRoutineBuildable = {
        CreateRoutineBuilder(dependency: self)
    }()
    
    var appHomeViewController: AppHomeViewControllable
    private let rootViewController: AppRootViewController
            
    var appTutorialViewController: ViewControllable
    var startTimerViewController: ViewControllable
    var timerEditViewController: ViewControllable
    
    init(
        dependency: AppRootDependency,
        viewController: AppRootViewController
    ) {
        //Base Domain
        let appendOnlyStore = CDAppendOnlyStore()
        let eventStore = EventStoreImp(appendOnlyStore: appendOnlyStore)
        let snapshotRepository = CDSnapshotRepository()
        
        
        //Factory
        let routineFactory = CDRoutineFactory()
        let recordFactory = CDRecordFactory()
        let timerFactory = CDTimerFactory()
        let profileFactory = CDProfileFactory()
                
        //Service
        let routineService = RoutineService()
                
        //Projection
        routineProjection = try! RoutineProjection()
        reminderProjection = try! ReminderProjection()
        recordProjection = try! RecordProjection()
        timerProjection = try! TimerProjection()
        profileProjection = try! ProfileProjection()
        
        //ReadModel
        routineReadModel = try! RoutineReadModelFacadeImp()
        repeatReadModel = try! RepeatReadModelFacadeImp()
        reminderReadModel = try! ReminderReadModelFacadeImp()
                        
        timerReadModel = try! TimerReadModelFacadeImp()
        
        routineRecordReadModel = try! RoutineRecordReadModelFacadeImp()
        timerRecordReadModel = try! TimerRecordReadModelFacadeImp()
        
        profileReadModel = try! ProfileReadModelFacadeImp()
        
        //ApplicationService
        self.routineApplicationService = RoutineApplicationService(
            eventStore: eventStore,
            snapshotRepository: snapshotRepository,
            routineFactory: routineFactory,
            routineService: routineService
        )
        
        self.recordApplicationService = RecordApplicationService(
            eventStore: eventStore,
            snapshotRepository: snapshotRepository,
            recordFactory: recordFactory
        )                
        
        self.timerApplicationService = TimerApplicationService(
            eventStore: eventStore,
            snapshotRepository: snapshotRepository,
            timerFactory: timerFactory
        )
        
        self.profileApplicationService = ProfileApplicationService(
            eventStore: eventStore,
            snapshotRepository: snapshotRepository,
            profileFactory: profileFactory
        )
        
        //Repository
        self.routineRepository = RoutineRepositoryImp(
            routineReadModel: routineReadModel,
            repeatReadModel: repeatReadModel,
            recordReadModel: routineRecordReadModel,
            reminderReadModel: reminderReadModel
        )
                        
        self.timerRepository = TimerRepositoryImp(
            timerReadModel: timerReadModel,
            recordModel: timerRecordReadModel
        )
        
        self.recordRepository = RecordRepositoryImp(
            routineReadModel: routineReadModel,
            routineRecordReadMoel: routineRecordReadModel,
            timerRecordReadModel: timerRecordReadModel
        )
    
        self.profileRepository = ProfileRepositoryImp(
            profileReadModel: profileReadModel
        )
                
        self.reminderRepository = ReminderRepositoryImp(
            reminderReadModel: reminderReadModel
        )

        self.appHomeViewController = viewController
        self.rootViewController = viewController

        self.appTutorialViewController = rootViewController
        self.startTimerViewController = rootViewController.topViewControllable
        self.timerEditViewController = rootViewController.topViewControllable
        
        super.init(dependency: dependency)
    }
    
    

}
