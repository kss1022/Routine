//
//  AddTabataTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/30/23.
//

import ModernRIBs

protocol AddTabataTimerDependency: Dependency {
    var timerApplicationService: TimerApplicationService{ get }
    var timerRepository: TimerRepository{ get }
    var timerRecordRepository: TimerRecordRepository{ get }
}

final class AddTabataTimerComponent: Component<AddTabataTimerDependency>, TimerSectionEditDependency, TimerEditTitleDependency, TimerSectionListDependency , AddTabataTimerInteractorDependency {    
    var timerApplicationService: TimerApplicationService{ dependency.timerApplicationService }
    var timerRepository: TimerRepository{ dependency.timerRepository }
    var timerRecordRepository: TimerRecordRepository{ dependency.timerRecordRepository }
    
    var sectionLists: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>{ sectionListsSubject }
    var sectionListsSubject = CurrentValuePublisher<[TimerSectionListModel]>([])
}

// MARK: - Builder

protocol AddTabataTimerBuildable: Buildable {
    func build(withListener listener: AddTabataTimerListener) -> AddTabataTimerRouting
}

final class AddTabataTimerBuilder: Builder<AddTabataTimerDependency>, AddTabataTimerBuildable {

    override init(dependency: AddTabataTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AddTabataTimerListener) -> AddTabataTimerRouting {
        let component = AddTabataTimerComponent(dependency: dependency)
        let viewController = AddTabataTimerViewController()
        let interactor = AddTabataTimerInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let timerEditTitleBuilder = TimerEditTitleBuilder(dependency: component)
        let timerSectionEditBuilder = TimerSectionEditBuilder(dependency: component)
        let timerSectionListBuilder = TimerSectionListBuilder(dependency: component)
        
        return AddTabataTimerRouter(
            interactor: interactor,
            viewController: viewController,
            timerEditTitleBuildable: timerEditTitleBuilder,
            timerSectionListBuildable: timerSectionListBuilder,
            timerSectionEditBuildable: timerSectionEditBuilder
        )
    }
}
