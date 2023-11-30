//
//  AppTutorialTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/29/23.
//

import ModernRIBs

protocol AppTutorialTimerDependency: Dependency {
    var timerApplicationService: TimerApplicationService{ get }
}

final class AppTutorialTimerComponent: Component<AppTutorialTimerDependency>, AppTutorialTimerInteractorDependency {
    var timerApplicationService: TimerApplicationService{ dependency.timerApplicationService }
}

// MARK: - Builder

protocol AppTutorialTimerBuildable: Buildable {
    func build(withListener listener: AppTutorialTimerListener) -> AppTutorialTimerRouting
}

final class AppTutorialTimerBuilder: Builder<AppTutorialTimerDependency>, AppTutorialTimerBuildable {

    override init(dependency: AppTutorialTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AppTutorialTimerListener) -> AppTutorialTimerRouting {
        let component = AppTutorialTimerComponent(dependency: dependency)
        let viewController = AppTutorialTimerViewController()
        let interactor = AppTutorialTimerInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return AppTutorialTimerRouter(interactor: interactor, viewController: viewController)
    }
}
