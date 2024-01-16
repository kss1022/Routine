//
//  EditFocusTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 1/15/24.
//

import ModernRIBs
import Combine

protocol EditFocusTimerDependency: Dependency {
    var timerApplicationService: TimerApplicationService{ get }
    var timerRepository: TimerRepository{ get }
    
    var focusTimerSubject: CurrentValueSubject<FocusTimerModel?, Error>{ get }
}

final class EditFocusTimerComponent: Component<EditFocusTimerDependency>, TimerEditTitleDependency , TimerEditMinutesDependency, EditFocusTimerInteractorDependency {
    var timerApplicationService: TimerApplicationService{ dependency.timerApplicationService}
    var timerRepository: TimerRepository{ dependency.timerRepository }    
    var focusTimerSubject: CurrentValueSubject<FocusTimerModel?, Error>{ dependency.focusTimerSubject }
}

// MARK: - Builder

protocol EditFocusTimerBuildable: Buildable {
    func build(withListener listener: EditFocusTimerListener) -> EditFocusTimerRouting
}

final class EditFocusTimerBuilder: Builder<EditFocusTimerDependency>, EditFocusTimerBuildable {

    override init(dependency: EditFocusTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EditFocusTimerListener) -> EditFocusTimerRouting {
        let component = EditFocusTimerComponent(dependency: dependency)
        let viewController = EditFocusTimerViewController()
        let interactor = EditFocusTimerInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let titleEditTitleBuilder = TimerEditTitleBuilder(dependency: component)
        let timerEditMinutesBuilder = TimerEditMinutesBuilder(dependency: component)

        
        return EditFocusTimerRouter(
            interactor: interactor,
            viewController: viewController,
            timerEditTitleBuildable: titleEditTitleBuilder,
            timerEditMinutesBuildable: timerEditMinutesBuilder
        )
    }
}
