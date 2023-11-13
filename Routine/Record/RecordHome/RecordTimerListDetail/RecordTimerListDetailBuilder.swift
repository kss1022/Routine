//
//  RecordTimerListDetailBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol RecordTimerListDetailDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RecordTimerListDetailComponent: Component<RecordTimerListDetailDependency>, TimerDataDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
        let interactor = RecordTimerListDetailInteractor(presenter: viewController)
        interactor.listener = listener
        
        let timerDataBuilder = TimerDataBuilder(dependency: component)
        
        return RecordTimerListDetailRouter(
            interactor: interactor,
            viewController: viewController,
            timerDataBuildable: timerDataBuilder
        )
    }
}
