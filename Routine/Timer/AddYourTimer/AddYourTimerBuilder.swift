//
//  AddYourTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/30/23.
//

import ModernRIBs

protocol AddYourTimerDependency: Dependency {
    
    var addYourTimerBaseViewController: ViewControllable { get }
    
    var timerApplicationService: TimerApplicationService{ get }
    var timerRepository: TimerRepository{ get }
}

final class AddYourTimerComponent: Component<AddYourTimerDependency>,AddFocusTimerDependency, AddTabataTimerDependency, AddRoundTimerDependency, AddYourTimerInteractorDependency {

    var timerApplicationService: TimerApplicationService{ dependency.timerApplicationService }
    var timerRepository: TimerRepository{ dependency.timerRepository }
    
    let timerType: AddTimerType
    
    fileprivate var addYourTimerBaseViewController: ViewControllable {
        return dependency.addYourTimerBaseViewController
    }
    
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
        let interactor = AddYourTimerInteractor(dependency: component)
        interactor.listener = listener
        
        let addFocusTimerBuilder = AddFocusTimerBuilder(dependency: component)
        let addTabataTimerBuilder = AddTabataTimerBuilder(dependency: component)
        let addRoundTimerBuilder = AddRoundTimerBuilder(dependency: component)
        
        return AddYourTimerRouter(
            interactor: interactor,
            viewController: component.addYourTimerBaseViewController,
            addFocusTimerBuildable: addFocusTimerBuilder,
            addTabataTimerBuildable: addTabataTimerBuilder,
            addRoundTimerBuildable: addRoundTimerBuilder
        )
    }
}
