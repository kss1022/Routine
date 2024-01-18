//
//  StartTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/26/23.
//

import Foundation
import ModernRIBs
import Combine

protocol StartTimerDependency: Dependency {
    var recordApplicationService: RecordApplicationService{ get }
    var timerRepository: TimerRepository{ get }
    
    
    var startTimerViewController: ViewControllable { get }
}

final class StartTimerComponent: Component<StartTimerDependency>, FocusTimerDependency, TabataTimerDependency, RoundTimerDependency, StarTimerInteractorDependency {

    var recordApplicationService: RecordApplicationService{ dependency.recordApplicationService}
    var timerRepository: TimerRepository{ dependency.timerRepository }
    
    
    fileprivate var startTimerViewController: ViewControllable { dependency.startTimerViewController }

    var focusTimerSubject = CurrentValueSubject<FocusTimerModel?, Error>(nil)
    var tabataTimerSubject = CurrentValueSubject<TabataTimerModel?, Error>(nil)
    var roundTimerSubject = CurrentValueSubject<RoundTimerModel?, Error>(nil)
}

// MARK: - Builder

protocol StartTimerBuildable: Buildable {
    func build(withListener listener: StartTimerListener, timerId: UUID) -> StartTimerRouting
}

final class StartTimerBuilder: Builder<StartTimerDependency>, StartTimerBuildable {

    override init(dependency: StartTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: StartTimerListener, timerId: UUID) -> StartTimerRouting {
        let component = StartTimerComponent(dependency: dependency)
        let interactor = StartTimerInteractor(dependency: component, timerId: timerId)
        interactor.listener = listener
        
        let focusTimerBuilder = FocusTimerBuilder(dependency: component)
        let tabataTimerBuilder = TabataTimerBuilder(dependency: component)
        let roundTimerBuilder = RoundTimerBuilder(dependency: component)
        
        return StartTimerRouter(
            interactor: interactor,
            viewController: component.startTimerViewController, 
            focusTimerBuildable: focusTimerBuilder, 
            tabataTimerBuildable: tabataTimerBuilder,
            roundTimerBuildable: roundTimerBuilder
        )
    }
}
