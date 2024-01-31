//
//  RecordTimerListDetailBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol RecordTimerListDetailDependency: Dependency {
    var timerRecordRepository: TimerRecordRepository{ get }
}

final class RecordTimerListDetailComponent: Component<RecordTimerListDetailDependency>, TimerDataDependency, RecordTimerListDetailInteractableDependency {
    var timerRecordRepository: TimerRecordRepository{ dependency.timerRecordRepository }
}

// MARK: - Builder

protocol RecordTimerListDetailBuildable: Buildable {
    func build(withListener listener: RecordTimerListDetailListener) -> RecordTimerListDetailRouting
}

final class RecordTimerListDetailBuilder: Builder<RecordTimerListDetailDependency>, RecordTimerListDetailBuildable {

    override init(dependency: RecordTimerListDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RecordTimerListDetailListener) -> RecordTimerListDetailRouting {
        let component = RecordTimerListDetailComponent(dependency: dependency)
        let viewController = RecordTimerListDetailViewController()
        let interactor = RecordTimerListDetailInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let timerDataBuilder = TimerDataBuilder(dependency: component)
        
        return RecordTimerListDetailRouter(
            interactor: interactor,
            viewController: viewController,
            timerDataBuildable: timerDataBuilder
        )
    }
}
