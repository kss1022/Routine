//
//  SectionRoundTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs

protocol SectionRoundTimerDependency: Dependency {
    var model: SectionTimerModel{ get }
    var timer: AppTimer{ get }
}

final class SectionRoundTimerComponent: Component<SectionRoundTimerDependency>, SectionRoundTimerInteractorDependency {
    var model: SectionTimerModel{ dependency.model }
    var timer: AppTimer{ dependency.timer }
}

// MARK: - Builder

protocol SectionRoundTimerBuildable: Buildable {
    func build(withListener listener: SectionRoundTimerListener) -> SectionRoundTimerRouting
}

final class SectionRoundTimerBuilder: Builder<SectionRoundTimerDependency>, SectionRoundTimerBuildable {

    override init(dependency: SectionRoundTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SectionRoundTimerListener) -> SectionRoundTimerRouting {
        let component = SectionRoundTimerComponent(dependency: dependency)
        let viewController = SectionRoundTimerViewController()
        let interactor = SectionRoundTimerInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return SectionRoundTimerRouter(interactor: interactor, viewController: viewController)
    }
}
