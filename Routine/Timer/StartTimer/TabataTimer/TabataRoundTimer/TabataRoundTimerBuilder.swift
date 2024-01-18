//
//  TabataRoundTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import Foundation
import ModernRIBs
import Combine

protocol TabataRoundTimerDependency: Dependency {
    var tabataTimerSubject: CurrentValueSubject<TabataTimerModel?, Error>{ get }
    var time: ReadOnlyCurrentValuePublisher<TimeInterval>{ get }
    var state: ReadOnlyCurrentValuePublisher<TimerState>{ get }
    var section: ReadOnlyCurrentValuePublisher<TimeSectionModel?>{ get }
}

final class TabataRoundTimerComponent: Component<TabataRoundTimerDependency>, TabataRoundTimerInteractorDependency {
    var tabataTimerSubject: CurrentValueSubject<TabataTimerModel?, Error>{ dependency.tabataTimerSubject }
    var time: ReadOnlyCurrentValuePublisher<TimeInterval>{ dependency.time }    
    var state: ReadOnlyCurrentValuePublisher<TimerState>{ dependency.state }
    var section: ReadOnlyCurrentValuePublisher<TimeSectionModel?>{ dependency.section }
}

// MARK: - Builder

protocol TabataRoundTimerBuildable: Buildable {
    func build(withListener listener: TabataRoundTimerListener) -> TabataRoundTimerRouting
}

final class TabataRoundTimerBuilder: Builder<TabataRoundTimerDependency>, TabataRoundTimerBuildable {

    override init(dependency: TabataRoundTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TabataRoundTimerListener) -> TabataRoundTimerRouting {
        let component = TabataRoundTimerComponent(dependency: dependency)
        let viewController = TabataRoundTimerViewController()
        let interactor = TabataRoundTimerInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return TabataRoundTimerRouter(interactor: interactor, viewController: viewController)
    }
}
