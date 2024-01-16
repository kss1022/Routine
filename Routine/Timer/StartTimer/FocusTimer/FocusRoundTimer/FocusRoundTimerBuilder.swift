//
//  FocusRoundTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import ModernRIBs

protocol FocusRoundTimerDependency: Dependency {
    var model: FocusTimerModel{ get }
    var timer: AppFocusTimer{ get }
}

final class FocusRoundTimerComponent: Component<FocusRoundTimerDependency>, FocusRoundTimerInteractorDependency {
    var model: FocusTimerModel{ dependency.model}
    var timer: AppFocusTimer{ dependency.timer}
}

// MARK: - Builder

protocol FocusRoundTimerBuildable: Buildable {
    func build(withListener listener: FocusRoundTimerListener) -> FocusRoundTimerRouting
}

final class FocusRoundTimerBuilder: Builder<FocusRoundTimerDependency>, FocusRoundTimerBuildable {

    override init(dependency: FocusRoundTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FocusRoundTimerListener) -> FocusRoundTimerRouting {
        let component = FocusRoundTimerComponent(dependency: dependency)
        let viewController = FocusRoundTimerViewController()
        let interactor = FocusRoundTimerInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return FocusRoundTimerRouter(interactor: interactor, viewController: viewController)
    }
}
