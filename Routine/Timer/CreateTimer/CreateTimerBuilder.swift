//
//  CreateTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol CreateTimerDependency: Dependency {
    var timerApplicationService: TimerApplicationService{ get }
    var timerRepository: TimerRepository{ get }
}

final class CreateTimerComponent: Component<CreateTimerDependency>, AddYourTimerDependency {
    var timerRepository: TimerRepository{ dependency.timerRepository }
    var timerApplicationService: TimerApplicationService{ dependency.timerApplicationService }
}

// MARK: - Builder

protocol CreateTimerBuildable: Buildable {
    func build(withListener listener: CreateTimerListener) -> CreateTimerRouting
}

final class CreateTimerBuilder: Builder<CreateTimerDependency>, CreateTimerBuildable {

    override init(dependency: CreateTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CreateTimerListener) -> CreateTimerRouting {
        let component = CreateTimerComponent(dependency: dependency)
        let viewController = CreateTimerViewController()
        let interactor = CreateTimerInteractor(presenter: viewController)
        interactor.listener = listener
        
        let addYourTimerBuilder = AddYourTimerBuilder(dependency: component)
        
        return CreateTimerRouter(
            interactor: interactor,
            viewController: viewController,
            addYourTimerBuildable: addYourTimerBuilder
        )
    }
}
