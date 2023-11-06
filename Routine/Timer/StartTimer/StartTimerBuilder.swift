//
//  StartTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/26/23.
//

import Foundation
import ModernRIBs

protocol StartTimerDependency: Dependency {
    
    var recordApplicationService: RecordApplicationService{ get }
    
    var timerRepository: TimerRepository{ get }
    var startTimerBaseViewController: ViewControllable { get }
    
}

final class StartTimerComponent: Component<StartTimerDependency>, FocusTimerDependency, SectionTimerDependency, StarTimerInteractorDependency {

    var recordApplicationService: RecordApplicationService{ dependency.recordApplicationService}

    
    var timerRepository: TimerRepository{ dependency.timerRepository }
    fileprivate var startTimerBaseViewController: ViewControllable { dependency.startTimerBaseViewController }
    
    let timerId: UUID
    
    init(dependency: StartTimerDependency, timerId: UUID) {
        self.timerId = timerId
        super.init(dependency: dependency)
    }

    
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
        let component = StartTimerComponent(dependency: dependency, timerId: timerId)
        let interactor = StartTimerInteractor(dependency: component)
        interactor.listener = listener
        
        let focusTimerBuilder = FocusTimerBuilder(dependency: component)
        let sectionTimerBuilder = SectionTimerBuilder(dependency: component)
        
        return StartTimerRouter(
            interactor: interactor,
            viewController: component.startTimerBaseViewController, 
            focusTimerBuildable: focusTimerBuilder,
            sectionTimerBuildable: sectionTimerBuilder
        )
    }
}
