//
//  RecordCalendarBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/12/23.
//

import ModernRIBs

protocol RecordCalendarDependency: Dependency {
    var routineDetailRecord: ReadOnlyCurrentValuePublisher<RoutineDetailRecordModel?>{ get  }
}

final class RecordCalendarComponent: Component<RecordCalendarDependency>, RecordCalendarInteractorDependency {
    var routineDetailRecord: ReadOnlyCurrentValuePublisher<RoutineDetailRecordModel?>{ dependency.routineDetailRecord  }
}

// MARK: - Builder

protocol RecordCalendarBuildable: Buildable {
    func build(withListener listener: RecordCalendarListener) -> RecordCalendarRouting
}

final class RecordCalendarBuilder: Builder<RecordCalendarDependency>, RecordCalendarBuildable {

    override init(dependency: RecordCalendarDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RecordCalendarListener) -> RecordCalendarRouting {
        let component = RecordCalendarComponent(dependency: dependency)
        let viewController = RecordCalendarViewController()
        let interactor = RecordCalendarInteractor(presenter: viewController,dependency: component)
        interactor.listener = listener
        return RecordCalendarRouter(interactor: interactor, viewController: viewController)
    }
}
