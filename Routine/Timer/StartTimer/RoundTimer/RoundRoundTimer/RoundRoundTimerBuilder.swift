//
//  RoundRoundTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 1/18/24.
//

import Foundation
import ModernRIBs
import Combine

protocol RoundRoundTimerDependency: Dependency {
    var roundTimerSubject: CurrentValueSubject<RoundTimerModel?, Error>{ get }
    var section: ReadOnlyCurrentValuePublisher<TimeSectionModel?>{ get }
    
    var time: ReadOnlyCurrentValuePublisher<TimeInterval>{ get }
    var state: ReadOnlyCurrentValuePublisher<TimerState>{ get }
}

final class RoundRoundTimerComponent: Component<RoundRoundTimerDependency>, RoundRoundTimerInteractorDependency {
    var roundTimerSubject: CurrentValueSubject<RoundTimerModel?, Error>{ dependency.roundTimerSubject }
    var section: ReadOnlyCurrentValuePublisher<TimeSectionModel?>{ dependency.section }
    
    var time: ReadOnlyCurrentValuePublisher<TimeInterval>{ dependency.time }
    var state: ReadOnlyCurrentValuePublisher<TimerState>{ dependency.state }
}

// MARK: - Builder

protocol RoundRoundTimerBuildable: Buildable {
    func build(withListener listener: RoundRoundTimerListener) -> RoundRoundTimerRouting
}

final class RoundRoundTimerBuilder: Builder<RoundRoundTimerDependency>, RoundRoundTimerBuildable {

    override init(dependency: RoundRoundTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoundRoundTimerListener) -> RoundRoundTimerRouting {
        let component = RoundRoundTimerComponent(dependency: dependency)
        let viewController = RoundRoundTimerViewController()
        let interactor = RoundRoundTimerInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return RoundRoundTimerRouter(interactor: interactor, viewController: viewController)
    }
}
