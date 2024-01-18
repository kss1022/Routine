//
//  RoundProgressBuilder.swift
//  Routine
//
//  Created by 한현규 on 1/18/24.
//

import Foundation
import ModernRIBs
import Combine

protocol RoundProgressDependency: Dependency {
    var roundTimerSubject: CurrentValueSubject<RoundTimerModel?, Error>{ get}
    var totalTime: ReadOnlyCurrentValuePublisher<TimeInterval>{ get }
    var progress: ReadOnlyCurrentValuePublisher<RoundProgressModel?>{ get }
}

final class RoundProgressComponent: Component<RoundProgressDependency>, RoundProgressInteractorDependency {
    var roundTimerSubject: CurrentValueSubject<RoundTimerModel?, Error>{ dependency.roundTimerSubject }
    var totalTime: ReadOnlyCurrentValuePublisher<TimeInterval>{ dependency.totalTime }
    var progress: ReadOnlyCurrentValuePublisher<RoundProgressModel?>{ dependency.progress }
}

// MARK: - Builder

protocol RoundProgressBuildable: Buildable {
    func build(withListener listener: RoundProgressListener) -> RoundProgressRouting
}

final class RoundProgressBuilder: Builder<RoundProgressDependency>, RoundProgressBuildable {

    override init(dependency: RoundProgressDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoundProgressListener) -> RoundProgressRouting {
        let component = RoundProgressComponent(dependency: dependency)
        let viewController = RoundProgressViewController()
        let interactor = RoundProgressInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return RoundProgressRouter(interactor: interactor, viewController: viewController)
    }
}
