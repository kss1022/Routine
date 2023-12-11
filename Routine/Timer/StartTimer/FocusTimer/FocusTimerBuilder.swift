//
//  FocusTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import ModernRIBs
import Foundation

protocol FocusTimerDependency: Dependency {
    var recordApplicationService: RecordApplicationService{ get }
    var timerRepository: TimerRepository{ get }
}

final class FocusTimerComponent: Component<FocusTimerDependency>, FocusRoundTimerDependency, FocusTimerInteractorDependency {
    
    var recordApplicationService: RecordApplicationService{ dependency.recordApplicationService }
    var timerRepository: TimerRepository{ dependency.timerRepository }
    
    let model: TimerFocusModel
    let timer: AppFocusTimer

    
    init(dependency: FocusTimerDependency, model: TimerFocusModel) {
        self.model = model
        self.timer = AppTimerManager.shared.focusTimer(model: AppFocusTimerModel(model), id: model.timerId)
        super.init(dependency: dependency)
    }
    
}

// MARK: - Builder

protocol FocusTimerBuildable: Buildable {
    func build(withListener listener: FocusTimerListener, model: TimerFocusModel) -> FocusTimerRouting
}

final class FocusTimerBuilder: Builder<FocusTimerDependency>, FocusTimerBuildable {

    override init(dependency: FocusTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FocusTimerListener, model: TimerFocusModel) -> FocusTimerRouting {
        let component = FocusTimerComponent(dependency: dependency, model: model)
        let viewController = FocusTimerViewController()
        let interactor = FocusTimerInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let focusRoundTimerBuilder = FocusRoundTimerBuilder(dependency: component)
        
        return FocusTimerRouter(
            interactor: interactor,
            viewController: viewController,
            focusRoundTimerBuildable: focusRoundTimerBuilder            
        )
    }
}
