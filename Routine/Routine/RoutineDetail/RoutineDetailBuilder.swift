//
//  RoutineDetailBuilder.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import Foundation
import ModernRIBs

protocol RoutineDetailDependency: Dependency {
    var routineApplicationService: RoutineApplicationService{ get }
    var recordApplicationService: RecordApplicationService{ get }
    
    var routineRepository: RoutineRepository{ get }
    
}

final class RoutineDetailComponent: Component<RoutineDetailDependency>, RoutineEditDependency,  RoutineTitleDependency, RecordCalendarDependency, RoutineDetailInteractorDependency {
    
    
    var routineId: UUID
    var recordDate: Date

    var routineApplicationService: RoutineApplicationService{ dependency.routineApplicationService }
    var recordApplicationService: RecordApplicationService{ dependency.recordApplicationService }
    
    var routineRepository: RoutineRepository{ dependency.routineRepository }
        
    var routineDetail: ReadOnlyCurrentValuePublisher<RoutineDetailModel?>{ routineRepository.detail}
    var routineDetailRecord: ReadOnlyCurrentValuePublisher<RoutineDetailRecordModel?>{ routineRepository.detailRecords }
        
    
    init(dependency: RoutineDetailDependency, routineId: UUID, recordDate: Date) {
        self.routineId = routineId
        self.recordDate = recordDate
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol RoutineDetailBuildable: Buildable {
    func build(withListener listener: RoutineDetailListener, routineId: UUID, recordDate: Date) -> RoutineDetailRouting
}

final class RoutineDetailBuilder: Builder<RoutineDetailDependency>, RoutineDetailBuildable {

    override init(dependency: RoutineDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineDetailListener, routineId: UUID, recordDate: Date) -> RoutineDetailRouting {
        let component = RoutineDetailComponent(dependency: dependency, routineId: routineId, recordDate: recordDate)
        let viewController = RoutineDetailViewController()
        let interactor = RoutineDetailInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        
        let routineEditBuilder = RoutineEditBuilder(dependency: component)
        let routineTitleBuilder = RoutineTitleBuilder(dependency: component)
        let recordCalendarBuilder = RecordCalendarBuilder(dependency: component)
        
        return RoutineDetailRouter(
            interactor: interactor,
            viewController: viewController,
            routineEditBuildable: routineEditBuilder,
            routineTitleBuildable: routineTitleBuilder,
            recordCalendarBuildable: recordCalendarBuilder
        )
    }
}
