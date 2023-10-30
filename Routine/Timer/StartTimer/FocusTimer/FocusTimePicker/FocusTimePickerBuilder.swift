//
//  FocusTimePickerBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import ModernRIBs

protocol FocusTimePickerDependency: Dependency {
    var model: TimerFocusModel{ get }
    var timer: AppFocusTimer{ get }
}

final class FocusTimePickerComponent: Component<FocusTimePickerDependency>, FocusTimePickerInteractorDependency {
    var model: TimerFocusModel{ dependency.model}
    var timer: AppFocusTimer{ dependency.timer }
}

// MARK: - Builder

protocol FocusTimePickerBuildable: Buildable {
    func build(withListener listener: FocusTimePickerListener) -> FocusTimePickerRouting
}

final class FocusTimePickerBuilder: Builder<FocusTimePickerDependency>, FocusTimePickerBuildable {

    override init(dependency: FocusTimePickerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FocusTimePickerListener) -> FocusTimePickerRouting {
        let component = FocusTimePickerComponent(dependency: dependency)
        let viewController = FocusTimePickerViewController()
        let interactor = FocusTimePickerInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return FocusTimePickerRouter(interactor: interactor, viewController: viewController)
    }
}
