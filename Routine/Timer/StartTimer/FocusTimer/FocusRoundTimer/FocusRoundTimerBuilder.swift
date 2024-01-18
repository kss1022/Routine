//
//  FocusRoundTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import Foundation
import ModernRIBs
import Combine

protocol FocusRoundTimerDependency: Dependency {
    var focusTimerSubject: CurrentValueSubject<FocusTimerModel?, Error>{ get }
    var time: ReadOnlyCurrentValuePublisher<TimeInterval>{ get }
    var state: ReadOnlyCurrentValuePublisher<TimerState>{ get }
}

final class FocusRoundTimerComponent: Component<FocusRoundTimerDependency>, FocusRoundTimerInteractorDependency {
    var focusTimerSubject: CurrentValueSubject<FocusTimerModel?, Error>{ dependency.focusTimerSubject }
    var time: ReadOnlyCurrentValuePublisher<TimeInterval>{ dependency.time }
    var state: ReadOnlyCurrentValuePublisher<TimerState>{ dependency.state }
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
