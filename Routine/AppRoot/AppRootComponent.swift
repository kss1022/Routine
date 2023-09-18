//
//  AppRootComponent.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation
import ModernRIBs


final class AppRootComponent: Component<AppRootDependency> , RoutineHomeDependency, RecordHomeDependency, TimerHomeDependency, ProfileHomeDependency{

    
    var routineApplicationService: RoutineApplicationService
    var routineProjection: RoutineProjection
    
    override init(
        dependency: AppRootDependency
    ) {
        
        
        let appendOnlyStore = CDAppendOnlyStore()
        let eventStore = EventStoreImp(appendOnlyStore: appendOnlyStore)
        let snapshotRepository = CDSnapshotRepository()
                
        let routineFactory = CDRoutineFactory()
        let routineService = RoutineService()

        
        self.routineApplicationService = RoutineApplicationService(
            eventStore: eventStore,
            snapshotRepository: snapshotRepository,
            routineFactory: routineFactory,
            routineService: routineService
        )
        
        self.routineProjection = RoutineProjection()

        
        super.init(dependency: dependency)
    }
    
    
}
