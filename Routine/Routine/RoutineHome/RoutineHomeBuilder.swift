//
//  RoutineHomeBuilder.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol RoutineHomeDependency: Dependency {
    var routineApplicationService: RoutineApplicationService{ get }
    var recordApplicationService: RecordApplicationService{ get }
    var routineRepository: RoutineRepository{ get }
    var routineRecordRepository: RoutineRecordRepository{ get }
    
    var createRoutineBuildable: CreateRoutineBuildable{ get }
}

final class RoutineHomeComponent: Component<RoutineHomeDependency> , RoutineHomeInteractorDependency, RoutineDetailDependency, CreateRoutineDependency, RoutineWeekCalendarDependency, RoutineListDependency{
    
            
    var routineApplicationService: RoutineApplicationService{ dependency.routineApplicationService }
    var recordApplicationService: RecordApplicationService{ dependency.recordApplicationService }
    var routineRepository: RoutineRepository{ dependency.routineRepository }
    var routineRecordRepository: RoutineRecordRepository{ dependency.routineRecordRepository }

    
    var createRoutineBuildable: CreateRoutineBuildable{ dependency.createRoutineBuildable }
}

// MARK: - Builder

protocol RoutineHomeBuildable: Buildable {
    func build(withListener listener: RoutineHomeListener) -> RoutineHomeRouting
}

final class RoutineHomeBuilder: Builder<RoutineHomeDependency>, RoutineHomeBuildable {

    override init(dependency: RoutineHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineHomeListener) -> RoutineHomeRouting {
        let component = RoutineHomeComponent(dependency: dependency)
        let viewController = RoutineHomeViewController()
        let interactor = RoutineHomeInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        
        let routineWeekCalendarBuilder = RoutineWeekCalendarBuilder(dependency: component)
        let routineListBuilder = RoutineListBuilder(dependency: component)
        let routineDetailBuilder = RoutineDetailBuilder(dependency: component)
        
                                
        return RoutineHomeRouter(
            interactor: interactor,
            viewController: viewController, 
            routineDetailBuildable: routineDetailBuilder,
            createRoutineBuildable: component.createRoutineBuildable, 
            routineWeekCalendarBuildable: routineWeekCalendarBuilder,
            routineListBuildable: routineListBuilder
        )
    }
}
