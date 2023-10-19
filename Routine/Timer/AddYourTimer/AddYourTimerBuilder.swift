//
//  AddYourTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol AddYourTimerDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AddYourTimerComponent: Component<AddYourTimerDependency>, TimerSectionEditDependency, TimerSectionListDependency {

    
    let timerType: AddTimerType
    
    init(dependency: AddYourTimerDependency, timerType: AddTimerType) {
        self.timerType = timerType
        super.init(dependency: dependency)
    }
    
}

// MARK: - Builder

protocol AddYourTimerBuildable: Buildable {
    func build(withListener listener: AddYourTimerListener, timerType: AddTimerType) -> AddYourTimerRouting
}

final class AddYourTimerBuilder: Builder<AddYourTimerDependency>, AddYourTimerBuildable {

    override init(dependency: AddYourTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AddYourTimerListener, timerType: AddTimerType) -> AddYourTimerRouting {
        let component = AddYourTimerComponent(dependency: dependency, timerType: timerType)
        let viewController = AddYourTimerViewController()
        let interactor = AddYourTimerInteractor(presenter: viewController)
        interactor.listener = listener
        
        let timerSectionEditBuilder = TimerSectionEditBuilder(dependency: component)
        let timerSectionListBuilder = TimerSectionListBuilder(dependency: component)
        
        return AddYourTimerRouter(
            interactor: interactor,
            viewController: viewController,
            timerSectionEditBuildable: timerSectionEditBuilder,
            timerSectionListBuildable: timerSectionListBuilder
        )
    }
}
