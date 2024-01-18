//
//  TabataProgressBuilder.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import Foundation
import ModernRIBs
import Combine

protocol TabataProgressDependency: Dependency {
    var tabataTimerSubject: CurrentValueSubject<TabataTimerModel?, Error>{ get}
    var totalTime: ReadOnlyCurrentValuePublisher<TimeInterval>{ get }
    var progress: ReadOnlyCurrentValuePublisher<TabataProgressModel?>{ get }
}

final class TabataProgressComponent: Component<TabataProgressDependency>, TabataProgressInteractorDependency {
    var tabataTimerSubject: CurrentValueSubject<TabataTimerModel?, Error>{ dependency.tabataTimerSubject }
    var totalTime: ReadOnlyCurrentValuePublisher<TimeInterval>{ dependency.totalTime }
    var progress: ReadOnlyCurrentValuePublisher<TabataProgressModel?>{ dependency.progress }
}

// MARK: - Builder

protocol TabataProgressBuildable: Buildable {
    func build(withListener listener: TabataProgressListener) -> TabataProgressRouting
}

final class TabataProgressBuilder: Builder<TabataProgressDependency>, TabataProgressBuildable {

    override init(dependency: TabataProgressDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TabataProgressListener) -> TabataProgressRouting {
        let component = TabataProgressComponent(dependency: dependency)
        let viewController = TabataProgressViewController()
        let interactor = TabataProgressInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return TabataProgressRouter(interactor: interactor, viewController: viewController)
    }
}
