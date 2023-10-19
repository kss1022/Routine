//
//  CreateTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol CreateTimerDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CreateTimerComponent: Component<CreateTimerDependency>, AddYourTimerDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
