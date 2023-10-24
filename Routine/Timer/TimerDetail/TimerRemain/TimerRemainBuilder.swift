//
//  TimerRemainBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/24/23.
//

import ModernRIBs

protocol TimerRemainDependency: Dependency {
    var detail: TimerDetailModel{ get }
    var timer: AppTimer{ get }
    var model: BaseTimerModel{ get }
}

final class TimerRemainComponent: Component<TimerRemainDependency>, TimerRemainInteractorDependency{
    var detail: TimerDetailModel{ dependency.detail }
    var timer: AppTimer{ dependency.timer }
    var model: BaseTimerModel{ dependency.model }
}

// MARK: - Builder

protocol TimerRemainBuildable: Buildable {
    func build(withListener listener: TimerRemainListener) -> TimerRemainRouting
}

final class TimerRemainBuilder: Builder<TimerRemainDependency>, TimerRemainBuildable {

    override init(dependency: TimerRemainDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerRemainListener) -> TimerRemainRouting {
        let component = TimerRemainComponent(dependency: dependency)
        let viewController = TimerRemainViewController()
        let interactor = TimerRemainInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return TimerRemainRouter(interactor: interactor, viewController: viewController)
    }
}
