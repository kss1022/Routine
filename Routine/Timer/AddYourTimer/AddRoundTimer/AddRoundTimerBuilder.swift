//
//  AddRoundTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/30/23.
//

import ModernRIBs

protocol AddRoundTimerDependency: Dependency {
    var timerApplicationService: TimerApplicationService{ get }
    var timerRepository: TimerRepository{ get }
}

final class AddRoundTimerComponent: Component<AddRoundTimerDependency>,TimerSectionEditDependency, TimerEditTitleDependency, TimerSectionListDependency , AddRoundTimerInteractorDependency  {

    var timerApplicationService: TimerApplicationService{ dependency.timerApplicationService }
    var timerRepository: TimerRepository{ dependency.timerRepository }
    
    var sectionLists: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>{ sectionListsSubject }
    var sectionListsSubject = CurrentValuePublisher<[TimerSectionListModel]>([])}

// MARK: - Builder

protocol AddRoundTimerBuildable: Buildable {
    func build(withListener listener: AddRoundTimerListener) -> AddRoundTimerRouting
}

final class AddRoundTimerBuilder: Builder<AddRoundTimerDependency>, AddRoundTimerBuildable {

    override init(dependency: AddRoundTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AddRoundTimerListener) -> AddRoundTimerRouting {
        let component = AddRoundTimerComponent(dependency: dependency)
        let viewController = AddRoundTimerViewController()
        let interactor = AddRoundTimerInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let timerEditTitleBuilder = TimerEditTitleBuilder(dependency: component)
        let timerSectionEditBuilder = TimerSectionEditBuilder(dependency: component)
        let timerSectionListBuilder = TimerSectionListBuilder(dependency: component)
        
        
        return AddRoundTimerRouter(
            interactor: interactor,
            viewController: viewController,
            timerEditTitleBuildable: timerEditTitleBuilder,
            timerSectionListBuildable: timerSectionListBuilder,
            timerSectionEditBuildable: timerSectionEditBuilder
        )
    }
}
