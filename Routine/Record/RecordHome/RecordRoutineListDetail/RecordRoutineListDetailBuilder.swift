//
//  RecordRoutineListDetailBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RecordRoutineListDetailDependency: Dependency {
    var routineRecordRepository: RoutineRecordRepository{ get }
}

final class RecordRoutineListDetailComponent: Component<RecordRoutineListDetailDependency> , RoutineDataDependency, RecordRoutineListDetailInteractorDependency{
    var routineRecordRepository: RoutineRecordRepository{ dependency.routineRecordRepository }
}

// MARK: - Builder

protocol RecordRoutineListDetailBuildable: Buildable {
    func build(withListener listener: RecordRoutineListDetailListener) -> RecordRoutineListDetailRouting
}

final class RecordRoutineListDetailBuilder: Builder<RecordRoutineListDetailDependency>, RecordRoutineListDetailBuildable {

    override init(dependency: RecordRoutineListDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RecordRoutineListDetailListener) -> RecordRoutineListDetailRouting {
        let component = RecordRoutineListDetailComponent(dependency: dependency)
        let viewController = RecordRoutineListDetailViewController()
        let interactor = RecordRoutineListDetailInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let routineDetailBuilder = RoutineDataBuilder(dependency: component)
        
        return RecordRoutineListDetailRouter(
            interactor: interactor,
            viewController: viewController,
            routineDataBuildable: routineDetailBuilder
        )
    }
}
