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
    
    var addYourTimerBaseViewController: ViewControllable{ createTimerController }
    private let createTimerController: ViewControllable
    
    init(dependency: CreateTimerDependency, createTimerController: ViewControllable) {
        self.createTimerController = createTimerController
        super.init(dependency: dependency)
    }

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
        let viewController = CreateTimerViewController()
        let component = CreateTimerComponent(dependency: dependency, createTimerController: viewController)
        
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
