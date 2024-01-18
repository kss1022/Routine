//
//  RoundTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 1/18/24.
//

import Foundation
import ModernRIBs
import Combine

protocol RoundTimerDependency: Dependency {
    var recordApplicationService: RecordApplicationService{ get }
    var timerRepository: TimerRepository{ get }
    
    var roundTimerSubject: CurrentValueSubject<RoundTimerModel?, Error>{ get }
}

final class RoundTimerComponent: Component<RoundTimerDependency>, RoundProgressDependency, RoundRoundTimerDependency, TimerNextSectionDependency, RoundTimerInteractorDependency {
    var recordApplicationService: RecordApplicationService{ dependency.recordApplicationService}
    var timerRepository: TimerRepository{ dependency.timerRepository }
    
    var roundTimerSubject: CurrentValueSubject<RoundTimerModel?, Error>{ dependency.roundTimerSubject}
    
    var time: ReadOnlyCurrentValuePublisher<TimeInterval>{ timeSubject }
    let timeSubject = CurrentValuePublisher<TimeInterval>(0)
    
    var totalTime: ReadOnlyCurrentValuePublisher<TimeInterval>{ totalSubject }
    var totalSubject = CurrentValuePublisher<TimeInterval>(0)
    
    var state: ReadOnlyCurrentValuePublisher<TimerState>{ stateSubject }
    let stateSubject = CurrentValuePublisher<TimerState>(.initialized)
    
    var section: ReadOnlyCurrentValuePublisher<TimeSectionModel?>{ sectionSubject }
    var sectionSubject = CurrentValuePublisher<TimeSectionModel?>(nil)
    
    var progress: ReadOnlyCurrentValuePublisher<RoundProgressModel?>{ progressSubject }
    var progressSubject = CurrentValuePublisher<RoundProgressModel?>(nil)
    
    var nextSection: ReadOnlyCurrentValuePublisher<TimeSectionModel?>{ nextSectionSubject }
    var nextSectionSubject = CurrentValuePublisher<TimeSectionModel?>(nil)
}

// MARK: - Builder

protocol RoundTimerBuildable: Buildable {
    func build(withListener listener: RoundTimerListener) -> RoundTimerRouting
}

final class RoundTimerBuilder: Builder<RoundTimerDependency>, RoundTimerBuildable {

    override init(dependency: RoundTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoundTimerListener) -> RoundTimerRouting {
        let component = RoundTimerComponent(dependency: dependency)
        let viewController = RoundTimerViewController()
        let interactor = RoundTimerInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener

        let roundProgressBuilder = RoundProgressBuilder(dependency: component)
        let roundRoundTimerBuilder = RoundRoundTimerBuilder(dependency: component)
        let timerNextSectionBuilder = TimerNextSectionBuilder(dependency: component)
        
        return RoundTimerRouter(
            interactor: interactor,
            viewController: viewController,
            roundProgressBuildable: roundProgressBuilder,
            roundRoundTimerBuildable: roundRoundTimerBuilder,
            timerNextSectionBuildable: timerNextSectionBuilder
        )
    }
}
