//
//  RecordRoutineListBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/6/23.
//

import ModernRIBs

protocol RecordRoutineListDependency: Dependency {
    var routineRecordRepository: RoutineRecordRepository{ get }
}

final class RecordRoutineListComponent: Component<RecordRoutineListDependency>, RecordRoutineListInteractorDependency {
    var routineRecordRepository: RoutineRecordRepository{ dependency.routineRecordRepository }
}

// MARK: - Builder

protocol RecordRoutineListBuildable: Buildable {
    func build(withListener listener: RecordRoutineListListener) -> RecordRoutineListRouting
}

final class RecordRoutineListBuilder: Builder<RecordRoutineListDependency>, RecordRoutineListBuildable {

    override init(dependency: RecordRoutineListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RecordRoutineListListener) -> RecordRoutineListRouting {
        let component = RecordRoutineListComponent(dependency: dependency)
        let viewController = RecordRoutineListViewController()
        let interactor = RecordRoutineListInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return RecordRoutineListRouter(interactor: interactor, viewController: viewController)
    }
}
