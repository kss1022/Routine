//
//  TabataTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import Foundation
import ModernRIBs
import Combine

protocol TabataTimerDependency: Dependency {
    var recordApplicationService: RecordApplicationService{ get }
    var timerRepository: TimerRepository{ get }
    
    var tabataTimerSubject: CurrentValueSubject<TabataTimerModel?, Error>{ get }
}

final class TabataTimerComponent: Component<TabataTimerDependency>,  TabataProgressDependency, TabataRoundTimerDependency, TimerNextSectionDependency, TabataTimerInteractorDependency{    
    var recordApplicationService: RecordApplicationService{ dependency.recordApplicationService}
    var timerRepository: TimerRepository{ dependency.timerRepository }
    
    var tabataTimerSubject: CurrentValueSubject<TabataTimerModel?, Error>{ dependency.tabataTimerSubject}
    
    var time: ReadOnlyCurrentValuePublisher<TimeInterval>{ timeSubject }
    let timeSubject = CurrentValuePublisher<TimeInterval>(0)
    
    var totalTime: ReadOnlyCurrentValuePublisher<TimeInterval>{ totalSubject }
    var totalSubject = CurrentValuePublisher<TimeInterval>(0)
    
    var state: ReadOnlyCurrentValuePublisher<TimerState>{ stateSubject }
    let stateSubject = CurrentValuePublisher<TimerState>(.initialized)
    
    var section: ReadOnlyCurrentValuePublisher<TimeSectionModel?>{ sectionSubject }
    var sectionSubject = CurrentValuePublisher<TimeSectionModel?>(nil)
    
    var progress: ReadOnlyCurrentValuePublisher<TabataProgressModel?>{ progressSubject }
    var progressSubject = CurrentValuePublisher<TabataProgressModel?>(nil)
    
    var nextSection: ReadOnlyCurrentValuePublisher<TimeSectionModel?>{ nextSectionSubject }
    var nextSectionSubject = CurrentValuePublisher<TimeSectionModel?>(nil)
}

// MARK: - Builder

protocol TabataTimerBuildable: Buildable {
    func build(withListener listener: TabataTimerListener) -> TabataTimerRouting
}

final class TabataTimerBuilder: Builder<TabataTimerDependency>, TabataTimerBuildable {

    override init(dependency: TabataTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TabataTimerListener) -> TabataTimerRouting {
        let component = TabataTimerComponent(dependency: dependency)
        let viewController = TabataTimerViewController()
        let interactor = TabataTimerInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let tabataProgressBuilder = TabataProgressBuilder(dependency: component)
        let tabataRoundTimerBuilder = TabataRoundTimerBuilder(dependency: component)
        let timerNextSectionBuilder = TimerNextSectionBuilder(dependency: component)
        
        return TabataTimerRouter(
            interactor: interactor,
            viewController: viewController,
            tabataProgressBuildable: tabataProgressBuilder,
            tabataRoundTimerBuildable: tabataRoundTimerBuilder,
            timerNextSectionBuildable: timerNextSectionBuilder
        )
    }
}
