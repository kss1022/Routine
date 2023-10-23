//
//  AddYourTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol AddYourTimerDependency: Dependency {
    var timerApplicationService: TimerApplicationService{ get }
    var timerRepository: TimerRepository{ get }
}

final class AddYourTimerComponent: Component<AddYourTimerDependency>, TimerSectionEditDependency, TimerEditTitleDependency, TimerSectionListDependency , AddYourTimeInteractorDependency{
        
    
    
    var timerApplicationService: TimerApplicationService{ dependency.timerApplicationService }
    var timerRepository: TimerRepository{ dependency.timerRepository }
    
    var timerType: AddTimerType
    var sectionLists: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>{ sectionListsSubject }
    var sectionListsSubject = CurrentValuePublisher<[TimerSectionListModel]>([])
    
    init(dependency: AddYourTimerDependency, timerType: AddTimerType) {
        self.timerType = timerType
        super.init(dependency: dependency)
        sectionListsSubject.send(timerRepository.baseSectionList(type: timerType))
    }
    
}

// MARK: - Builder

protocol AddYourTimerBuildable: Buildable {
    func build(withListener listener: AddYourTimerListener, timerType: AddTimerType) -> AddYourTimerRouting
}

final class AddYourTimerBuilder: Builder<AddYourTimerDependency>, AddYourTimerBuildable {

    override init(dependency: AddYourTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AddYourTimerListener, timerType: AddTimerType) -> AddYourTimerRouting {
        let component = AddYourTimerComponent(dependency: dependency, timerType: timerType)
        let viewController = AddYourTimerViewController()
        let interactor = AddYourTimerInteractor(presenter: viewController,dependency: component)
        interactor.listener = listener
        
        let timerEditTitleBuilder = TimerEditTitleBuilder(dependency: component)
        let timerSectionEditBuilder = TimerSectionEditBuilder(dependency: component)
        let timerSectionListBuilder = TimerSectionListBuilder(dependency: component)
        
        return AddYourTimerRouter(
            interactor: interactor,
            viewController: viewController,
            timerEditTitleBuildable: timerEditTitleBuilder,
            timerSectionListBuildable: timerSectionListBuilder,
            timerSectionEditBuildable: timerSectionEditBuilder
        )
    }
}
