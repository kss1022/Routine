//
//  TimerDetailBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs

protocol TimerDetailDependency: Dependency {
    var timerRepository: TimerRepository{ get }
}

final class TimerDetailComponent: Component<TimerDetailDependency>, TimerRemainDependency, CircularTimerDependency, TimerNextSectionDependency, TimerDetailInteractorDependency {
    
    var timerRepository: TimerRepository{ dependency.timerRepository }
    
    let detail: TimerDetailModel
    let timer: AppTimer
    let model: BaseTimerModel
    
        
    override init(dependency: TimerDetailDependency) {
        self.detail = dependency.timerRepository.detail.value!
        
        
        switch detail.repeatModel{
        case .base(let model):
            let appTimerModel =  AppTimerModel(
                ready: model.ready.time,
                exercise: model.exercise.time,
                rest: model.rest.time,
                round: model.round.count,
                cycle: model.cycle?.count,
                cycleRest: model.cycleRest?.time,
                cooldown: model.cooldown.time
            )
            
            let timer = AppTimerManager.share.baseTimer(appTimerModel: appTimerModel, timerId: detail.timerId.uuidString)
            self.timer = timer
            self.model = model
        default: fatalError()
        }
        
        
        
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol TimerDetailBuildable: Buildable {
    func build(withListener listener: TimerDetailListener) -> TimerDetailRouting
}

final class TimerDetailBuilder: Builder<TimerDetailDependency>, TimerDetailBuildable {

    override init(dependency: TimerDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerDetailListener) -> TimerDetailRouting {
        let component = TimerDetailComponent(dependency: dependency)
        let viewController = TimerDetailViewController()
        let interactor = TimerDetailInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let timerRemainBuilder = TimerRemainBuilder(dependency: component)
        let circularTimerBuilder = CircularTimerBuilder(dependency: component)
        let timerNextSectionBuilder = TimerNextSectionBuilder(dependency: component)
        
        return TimerDetailRouter(
            interactor: interactor,
            viewController: viewController, 
            timerRemainBuildable: timerRemainBuilder,
            circularTimerBuildable: circularTimerBuilder,
            timerNextSectionBuildable: timerNextSectionBuilder
        )
    }
}
