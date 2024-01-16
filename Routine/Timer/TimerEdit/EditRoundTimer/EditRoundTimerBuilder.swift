//
//  EditRoundTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import ModernRIBs
import Combine

protocol EditRoundTimerDependency: Dependency {
    var timerApplicationService: TimerApplicationService{ get }
    var timerRepository: TimerRepository{ get }
    var roundTimerSubject: CurrentValueSubject<RoundTimerModel?, Error>{ get }
}

final class EditRoundTimerComponent: Component<EditRoundTimerDependency>, TimerSectionEditDependency, TimerEditTitleDependency, TimerSectionListDependency , EditRoundTimerInteractorDependency {
    var timerApplicationService: TimerApplicationService{ dependency.timerApplicationService }
    var timerRepository: TimerRepository{ dependency.timerRepository }
    var roundTimerSubject: CurrentValueSubject<RoundTimerModel?, Error>{ dependency.roundTimerSubject }
    
    var sectionLists: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>{ sectionListsSubject }
    var sectionListsSubject = CurrentValuePublisher<[TimerSectionListModel]>([])
}

// MARK: - Builder

protocol EditRoundTimerBuildable: Buildable {
    func build(withListener listener: EditRoundTimerListener) -> EditRoundTimerRouting
}

final class EditRoundTimerBuilder: Builder<EditRoundTimerDependency>, EditRoundTimerBuildable {

    override init(dependency: EditRoundTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EditRoundTimerListener) -> EditRoundTimerRouting {
        let component = EditRoundTimerComponent(dependency: dependency)
        let viewController = EditRoundTimerViewController()
        let interactor = EditRoundTimerInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let timerEditTitleBuilder = TimerEditTitleBuilder(dependency: component)
        let timerSectionEditBuilder = TimerSectionEditBuilder(dependency: component)
        let timerSectionListBuilder = TimerSectionListBuilder(dependency: component)
        
        return EditRoundTimerRouter(
            interactor: interactor,
            viewController: viewController,
            timerEditTitleBuildable: timerEditTitleBuilder,
            timerSectionListBuildable: timerSectionListBuilder,
            timerSectionEditBuildable: timerSectionEditBuilder
        )
    }
}
