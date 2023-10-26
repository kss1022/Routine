//
//  TimerSectionBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs

protocol TimerSectionDependency: Dependency {
    var timerRepository: TimerRepository{ get }
}

final class TimerSectionComponent: Component<TimerSectionDependency>, TimerRemainDependency, CircularTimerDependency, TimerNextSectionDependency, TimerSectionInteractorDependency {
    
    var timerRepository: TimerRepository{ dependency.timerRepository }
    
    let detail: TimerSectionsModel
    let timer: AppTimer
    
        
    override init(dependency: TimerSectionDependency) {
        self.detail = dependency.timerRepository.sections.value!
        
        
        let appTimerModel = AppTimerModel(
            ready: detail.ready.time,
            exercise: detail.exercise.time,
            rest: detail.rest.time,
            round: detail.round.count,
            cycle: detail.cycle?.count,
            cycleRest: detail.cycleRest?.time,
            cooldown: detail.cooldown.time
        )
        

        
        let timer = AppTimerManager.share.baseTimer(appTimerModel: appTimerModel, timerId: detail.timerId.uuidString)
        self.timer = timer
        

        
        super.init(dependency: dependency)
    }
}

// MARK: - Builder
protocol TimerSectionBuildable: Buildable {
    func build(withListener listener: TimerDetailListener) -> TimerSectionRouting
}

final class TimerSectionBuilder: Builder<TimerSectionDependency>, TimerSectionBuildable {

    override init(dependency: TimerSectionDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerDetailListener) -> TimerSectionRouting {
        let component = TimerSectionComponent(dependency: dependency)
        let viewController = TimerSectionViewController()
        let interactor = TimerSectionInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let timerRemainBuilder = TimerRemainBuilder(dependency: component)
        let circularTimerBuilder = CircularTimerBuilder(dependency: component)
        let timerNextSectionBuilder = TimerNextSectionBuilder(dependency: component)
        
        return TimerSectionRouter(
            interactor: interactor,
            viewController: viewController, 
            timerRemainBuildable: timerRemainBuilder,
            circularTimerBuildable: circularTimerBuilder,
            timerNextSectionBuildable: timerNextSectionBuilder
        )
    }
}
