//
//  EditTabataTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 1/16/24.
//

import ModernRIBs
import Combine

protocol EditTabataTimerDependency: Dependency {
    var timerApplicationService: TimerApplicationService{ get }
    var timerRepository: TimerRepository{ get }
    var tabataTimerSubject: CurrentValueSubject<TabataTimerModel?, Error>{ get }
}

final class EditTabataTimerComponent: Component<EditTabataTimerDependency>, TimerSectionEditDependency, TimerEditTitleDependency, TimerSectionListDependency , EditTabataTimerInteractorDependency {
    var timerApplicationService: TimerApplicationService{ dependency.timerApplicationService }
    var timerRepository: TimerRepository{ dependency.timerRepository }
    var tabataTimerSubject: CurrentValueSubject<TabataTimerModel?, Error>{ dependency.tabataTimerSubject }
    
    var sectionLists: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>{ sectionListsSubject }
    var sectionListsSubject = CurrentValuePublisher<[TimerSectionListModel]>([])
}

// MARK: - Builder

protocol EditTabataTimerBuildable: Buildable {
    func build(withListener listener: EditTabataTimerListener) -> EditTabataTimerRouting
}

final class EditTabataTimerBuilder: Builder<EditTabataTimerDependency>, EditTabataTimerBuildable {

    override init(dependency: EditTabataTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EditTabataTimerListener) -> EditTabataTimerRouting {
        let component = EditTabataTimerComponent(dependency: dependency)
        let viewController = EditTabataTimerViewController()
        let interactor = EditTabataTimerInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let timerEditTitleBuilder = TimerEditTitleBuilder(dependency: component)
        let timerSectionEditBuilder = TimerSectionEditBuilder(dependency: component)
        let timerSectionListBuilder = TimerSectionListBuilder(dependency: component)
        
        return EditTabataTimerRouter(
            interactor: interactor,
            viewController: viewController,
            timerEditTitleBuildable: timerEditTitleBuilder,
            timerSectionListBuildable: timerSectionListBuilder,
            timerSectionEditBuildable: timerSectionEditBuilder
        )
    }
}
