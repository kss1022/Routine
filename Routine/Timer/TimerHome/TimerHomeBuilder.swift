//
//  TimerHomeBuilder.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol TimerHomeDependency: Dependency {
    var timerApplicationService: TimerApplicationService{ get }
    var recordApplicationService: RecordApplicationService{ get }
    
    var timerRepository: TimerRepository{ get }
    var timerRecordRepository: TimerRecordRepository{ get }
    
    var startTimerViewController: ViewControllable{ get }
    var timerEditViewController: ViewControllable{ get }
}

final class TimerHomeComponent: Component<TimerHomeDependency>, TimerListDependency, StartTimerDependency, CreateTimerDependency, TimerEditDependency, TimerHomeInteractorDependency {
    var timerApplicationService: TimerApplicationService{ dependency.timerApplicationService }
    var recordApplicationService: RecordApplicationService{ dependency.recordApplicationService }
    
    var timerRepository: TimerRepository{ dependency.timerRepository }
    var timerRecordRepository: TimerRecordRepository{ dependency.timerRecordRepository }
    
    var startTimerViewController: ViewControllable{ dependency.startTimerViewController }
    var timerEditViewController: ViewControllable{ dependency.timerEditViewController }
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

        
        let timerListBuilder = TimerListBuilder(dependency: component)
        let startTimerBuilder = StartTimerBuilder(dependency: component)
        let createTimerBuilder = CreateTimerBuilder(dependency: component)
        let timerEditBuilder = TimerEditBuilder(dependency: component)
        
        return TimerHomeRouter(
            interactor: interactor,
            viewController: viewController,
            timerListBuildable: timerListBuilder,
            startTimerBuildable: startTimerBuilder,
            creatTimerBuildable: createTimerBuilder,
            timerEditBuildable: timerEditBuilder
        )
    }
}
