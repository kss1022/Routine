//
//  TimerEditBuilder.swift
//  Routine
//
//  Created by 한현규 on 1/16/24.
//

import Foundation
import ModernRIBs
import Combine

protocol TimerEditDependency: Dependency {
    var timerApplicationService: TimerApplicationService{ get }
    var timerRepository: TimerRepository{ get }
    var timerRecordRepository: TimerRecordRepository{ get }
    
    var timerEditViewController: ViewControllable { get }
}

final class TimerEditComponent: Component<TimerEditDependency>, EditFocusTimerDependency, EditTabataTimerDependency, EditRoundTimerDependency, TimerEditInteractorDependency {
    
    
    var timerApplicationService: TimerApplicationService{dependency.timerApplicationService}
    var timerRepository: TimerRepository{ dependency.timerRepository}
    var timerRecordRepository: TimerRecordRepository{ dependency.timerRecordRepository }
    
    fileprivate var timerEditViewController: ViewControllable { dependency.timerEditViewController }
    
        
    var focusTimerSubject = CurrentValueSubject<FocusTimerModel?, Error>(nil)
    var tabataTimerSubject = CurrentValueSubject<TabataTimerModel?, Error>(nil)
    var roundTimerSubject = CurrentValueSubject<RoundTimerModel?, Error>(nil)
}

// MARK: - Builder

protocol TimerEditBuildable: Buildable {
    func build(withListener listener: TimerEditListener, timerId: UUID) -> TimerEditRouting
}

final class TimerEditBuilder: Builder<TimerEditDependency>, TimerEditBuildable {

    override init(dependency: TimerEditDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerEditListener, timerId: UUID) -> TimerEditRouting {
        let component = TimerEditComponent(dependency: dependency)
        let interactor = TimerEditInteractor(dependency: component, timerId: timerId)
        interactor.listener = listener
        
        let editFocusTimerBuilder = EditFocusTimerBuilder(dependency: component)
        let editTabataTimerBuilder = EditTabataTimerBuilder(dependency: component)
        let editRoundTimerBuilder = EditRoundTimerBuilder(dependency: component)
        
        return TimerEditRouter(
            interactor: interactor,
            viewController: component.timerEditViewController,
            editFocusTimerBuildable: editFocusTimerBuilder,
            editTabataTimerBuildable: editTabataTimerBuilder,
            editRoundTimerBuildable: editRoundTimerBuilder
        )
    }
}
