//
//  FocusTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import Foundation
import ModernRIBs
import Combine

protocol FocusTimerDependency: Dependency {
    var recordApplicationService: RecordApplicationService{ get }
    var timerRepository: TimerRepository{ get }
    var focusTimerSubject: CurrentValueSubject<FocusTimerModel?, Error>{ get }
}

final class FocusTimerComponent: Component<FocusTimerDependency>, FocusRoundTimerDependency, FocusTimerInteractorDependency {
    
    var recordApplicationService: RecordApplicationService{ dependency.recordApplicationService }
    var timerRepository: TimerRepository{ dependency.timerRepository }
    
    var focusTimerSubject: CurrentValueSubject<FocusTimerModel?, Error>{ dependency.focusTimerSubject }

    
    var time: ReadOnlyCurrentValuePublisher<TimeInterval>{ timeSubject }
    let timeSubject = CurrentValuePublisher<TimeInterval>(0)
    
    var state: ReadOnlyCurrentValuePublisher<TimerState>{ stateSubject }
    let stateSubject = CurrentValuePublisher<TimerState>(.initialized)
}

// MARK: - Builder

protocol FocusTimerBuildable: Buildable {
    func build(withListener listener: FocusTimerListener) -> FocusTimerRouting
}

final class FocusTimerBuilder: Builder<FocusTimerDependency>, FocusTimerBuildable {

    override init(dependency: FocusTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FocusTimerListener) -> FocusTimerRouting {
        let component = FocusTimerComponent(dependency: dependency)
        let viewController = FocusTimerViewController()
        let interactor = FocusTimerInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let focusRoundTimerBuilder = FocusRoundTimerBuilder(dependency: component)
        
        return FocusTimerRouter(
            interactor: interactor,
            viewController: viewController,
            focusRoundTimerBuildable: focusRoundTimerBuilder            
        )
    }
}
