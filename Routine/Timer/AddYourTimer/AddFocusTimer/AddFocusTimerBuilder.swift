//
//  AddFocusTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/30/23.
//

import ModernRIBs

protocol AddFocusTimerDependency: Dependency {
    var timerApplicationService: TimerApplicationService{ get }
    var timerRepository: TimerRepository{ get }
    var timerRecordRepository: TimerRecordRepository{ get }
}

final class AddFocusTimerComponent: Component<AddFocusTimerDependency>, TimerEditTitleDependency , TimerEditMinutesDependency, AddFocusTimerInteractorDependency{
    var timerApplicationService: TimerApplicationService{ dependency.timerApplicationService}
    var timerRepository: TimerRepository{ dependency.timerRepository }
    var timerRecordRepository: TimerRecordRepository{ dependency.timerRecordRepository }
}

// MARK: - Builder

protocol AddFocusTimerBuildable: Buildable {
    func build(withListener listener: AddFocusTimerListener) -> AddFocusTimerRouting
}

final class AddFocusTimerBuilder: Builder<AddFocusTimerDependency>, AddFocusTimerBuildable {

    override init(dependency: AddFocusTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AddFocusTimerListener) -> AddFocusTimerRouting {
        let component = AddFocusTimerComponent(dependency: dependency)
        let viewController = AddFocusTimerViewController()
        let interactor = AddFocusTimerInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener

        let titleEditTitleBuilder = TimerEditTitleBuilder(dependency: component)
        let timerEditMinutesBuilder = TimerEditMinutesBuilder(dependency: component)
        
        return AddFocusTimerRouter(
            interactor: interactor,
            viewController: viewController,
            timerEditTitleBuildable: titleEditTitleBuilder,
            timerEditMinutesBuildable: timerEditMinutesBuilder
        )
    }
}
