//
//  RecordTimerListBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/9/23.
//

import ModernRIBs

protocol RecordTimerListDependency: Dependency {
    var timerRecordRepository: TimerRecordRepository{ get }
}

final class RecordTimerListComponent: Component<RecordTimerListDependency>, RecordTimerListInteractorDependency {
    var timerRecordRepository: TimerRecordRepository{ dependency.timerRecordRepository }
}

// MARK: - Builder

protocol RecordTimerListBuildable: Buildable {
    func build(withListener listener: RecordTimerListListener) -> RecordTimerListRouting
}

final class RecordTimerListBuilder: Builder<RecordTimerListDependency>, RecordTimerListBuildable {

    override init(dependency: RecordTimerListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RecordTimerListListener) -> RecordTimerListRouting {
        let component = RecordTimerListComponent(dependency: dependency)
        let viewController = RecordTimerListViewController()
        let interactor = RecordTimerListInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return RecordTimerListRouter(interactor: interactor, viewController: viewController)
    }
}
