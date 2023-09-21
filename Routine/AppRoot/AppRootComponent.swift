//
//  AppRootComponent.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation
import ModernRIBs


final class AppRootComponent: Component<AppRootDependency> , RoutineHomeDependency, RecordHomeDependency, TimerHomeDependency, ProfileHomeDependency{

    
    let routineApplicationService: RoutineApplicationService
    let routineProjection: RoutineProjection
    let routineReadModel: RoutineReadModelFacade
    
    override init(
        dependency: AppRootDependency
    ) {
        let appendOnlyStore = CDAppendOnlyStore()
        let eventStore = EventStoreImp(appendOnlyStore: appendOnlyStore)
        let snapshotRepository = CDSnapshotRepository()
                
        let routineFactory = CDRoutineFactory()
        let routineService = RoutineService()
        
        routineProjection = try! RoutineProjection()
        routineReadModel = try! RoutineReadModelFacade()
        
        self.routineApplicationService = RoutineApplicationService(
            eventStore: eventStore,
            snapshotRepository: snapshotRepository,
            routineFactory: routineFactory,
            routineService: routineService
        )
                        
        super.init(dependency: dependency)
    }
    
    

}
