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

final class TimerDetailComponent: Component<TimerDetailDependency>, CircularTimerDependency, TimerNextSectionDependency, TimerDetailInteractorDependency {
    
    var timerRepository: TimerRepository{ dependency.timerRepository }
    
    var sections: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>{ timerRepository.sections }
    
    var sectionIndex: ReadOnlyCurrentValuePublisher<Int>{ sectionIndexSubject }
    var sectionIndexSubject = CurrentValuePublisher<Int>(0)
    
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
        
        let circularTimerBuilder = CircularTimerBuilder(dependency: component)
        let timerNextSectionBuilder = TimerNextSectionBuilder(dependency: component)
        
        return TimerDetailRouter(
            interactor: interactor,
            viewController: viewController,
            circularTimerBuildable: circularTimerBuilder,
            timerNextSectionBuildable: timerNextSectionBuilder
        )
    }
}
