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
    
    var startTimerBaseViewController: ViewControllable{ get }
}

final class TimerHomeComponent: Component<TimerHomeDependency>, CreateTimerDependency, StartTimerDependency, TimerSelectDependency, TimerHomeInteractorDependency {
    
    
    var timerApplicationService: TimerApplicationService{ dependency.timerApplicationService }
    var timerRepository: TimerRepository{ dependency.timerRepository }
    
    var startTimerBaseViewController: ViewControllable{ dependency.startTimerBaseViewController }
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
        let startTimerBuilder = StartTimerBuilder(dependency: component)
        let timerSelectBuilder = TimerSelectBuilder(dependency: component)
        
        return TimerHomeRouter(
            interactor: interactor,
            viewController: viewController,
            creatTimerBuildable: createTimerBuilder,
            startTimerBuildable: startTimerBuilder,
            timerSelectBuildable: timerSelectBuilder
        )
    }
}
