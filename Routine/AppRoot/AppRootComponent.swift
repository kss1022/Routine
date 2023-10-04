//
//  AppRootComponent.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation
import ModernRIBs


final class AppRootComponent: Component<AppRootDependency> , RoutineHomeDependency, RecordHomeDependency, TimerHomeDependency, ProfileHomeDependency, CreateRoutineDependency{    

    
    let routineApplicationService: RoutineApplicationService
    let routineRepository: RoutineRepository
        
    private let routineProjection: RoutineProjection
    private let routineReadModel: RoutineReadModelFacade
    
    private let checkListProjection: CheckListProjection
    
    
    lazy var createRoutineBuildable: CreateRoutineBuildable = {
        CreateRoutineBuilder(dependency: self)
    }()
    
    private let appRootViewController: ViewControllable
    
    init(
        dependency: AppRootDependency,
        viewController: ViewControllable
    ) {
        let appendOnlyStore = CDAppendOnlyStore()
        let eventStore = EventStoreImp(appendOnlyStore: appendOnlyStore)
        let snapshotRepository = CDSnapshotRepository()
                
        let routineFactory = CDRoutineFactory()
        let routineService = RoutineService()
        
        let checkListFactory = CDCheckListFactory()
        
        routineProjection = try! RoutineProjection()
        routineReadModel = try! RoutineReadModelFacadeImp()
        
        checkListProjection = CheckListProjection()
        
        self.routineApplicationService = RoutineApplicationService(
            eventStore: eventStore,
            snapshotRepository: snapshotRepository,
            routineFactory: routineFactory,
            routineService: routineService,
            checkListFactory: checkListFactory
        )
        
        self.routineRepository = RoutineRepositoryImp(routineReadModel: routineReadModel)
         
        self.appRootViewController = viewController
        super.init(dependency: dependency)
    }
    
    

}
