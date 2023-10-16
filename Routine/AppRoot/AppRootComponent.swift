//
//  AppRootComponent.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation
import ModernRIBs


final class AppRootComponent: Component<AppRootDependency> , RoutineHomeDependency, RecordHomeDependency, TimerHomeDependency, ProfileHomeDependency, CreateRoutineDependency{    

    //MARK: ApplicationService
    let routineApplicationService: RoutineApplicationService
    let recordApplicationService: RecordApplicationService
    
    //MARK: ReadModel
    private let routineReadModel: RoutineReadModelFacade
    private let repeatReadModel: RepeatReadModelFacade
    private let recordReadModel: RecordReadModelFacade
    private let reminderReadModel: ReminderReadModelFacade
    
    //MAKR: Projection
    private let routineProjection: RoutineProjection
    private let recordProjection: RecordProjection
    
    //MARK: Repository
    let routineRepository: RoutineRepository
    
    
    
    
    lazy var createRoutineBuildable: CreateRoutineBuildable = {
        CreateRoutineBuilder(dependency: self)
    }()
    
    private let appRootViewController: ViewControllable
    
    init(
        dependency: AppRootDependency,
        viewController: ViewControllable
    ) {
        //Base Domain
        let appendOnlyStore = CDAppendOnlyStore()
        let eventStore = EventStoreImp(appendOnlyStore: appendOnlyStore)
        let snapshotRepository = CDSnapshotRepository()
        
        
        //Factory
        let routineFactory = CDRoutineFactory()
        let recordFactory = CDRecordFactory()
                
        //Service
        let routineService = RoutineService()
                
        //Projection
        routineProjection = try! RoutineProjection()        
        recordProjection = try! RecordProjection()
        
        
        //ReadModel
        routineReadModel = try! RoutineReadModelFacadeImp()
        repeatReadModel = try! RepeatReadModelFacadeImp()
        recordReadModel = try! RecordReadModelFacadeImp()
        reminderReadModel = try! ReminderReadModelFacadeImp()
        
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
        
        //Repository
        self.routineRepository = RoutineRepositoryImp(
            routineReadModel: routineReadModel,
            repeatReadModel: repeatReadModel,
            recordReadModel: recordReadModel,
            reminderReadModel: reminderReadModel
        )
        
         
        self.appRootViewController = viewController
        super.init(dependency: dependency)
    }
    
    

}
