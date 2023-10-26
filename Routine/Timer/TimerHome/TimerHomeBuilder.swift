//
//  TimerHomeBuilder.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol TimerHomeDependency: Dependency {
    var timerApplicationService: TimerApplicationService{ get }
    var timerRepository: TimerRepository{ get }    
}

final class TimerHomeComponent: Component<TimerHomeDependency>, CreateTimerDependency, TimerSectionDependency, TimerSelectDependency, TimerHomeInteractorDependency {
    
    var timerApplicationService: TimerApplicationService{ dependency.timerApplicationService }
    var timerRepository: TimerRepository{ dependency.timerRepository }
}

// MARK: - Builder

protocol TimerHomeBuildable: Buildable {
    func build(withListener listener: TimerHomeListener) -> TimerHomeRouting
}

final class TimerHomeBuilder: Builder<TimerHomeDependency>, TimerHomeBuildable {

    override init(dependency: TimerHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerHomeListener) -> TimerHomeRouting {
        let component = TimerHomeComponent(dependency: dependency)
        let viewController = TimerHomeViewController()
        let interactor = TimerHomeInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener

        
        let createTimerBuilder = CreateTimerBuilder(dependency: component)
        let timerSectionBuilder = TimerSectionBuilder(dependency: component)
        let timerSelectBuilder = TimerSelectBuilder(dependency: component)
        
        return TimerHomeRouter(
            interactor: interactor,
            viewController: viewController,
            creatTimerBuildable: createTimerBuilder,
            timerSectionBuildable: timerSectionBuilder,
            timerSelectBuildable: timerSelectBuilder
        )
    }
}
