//
//  AddTabataTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/30/23.
//

import Foundation
import ModernRIBs

protocol AddTabataTimerRouting: ViewableRouting {
    func attachTimerSectionEdit(sectionList: TimerSectionListViewModel)
    func detachTimerSectionEdit()
    
    func attachTimerEditTitle()
    func attachTimerSectionList()
}

protocol AddTabataTimerPresentable: Presentable {
    var listener: AddTabataTimerPresentableListener? { get set }
    func setTitle(title: String)
}

protocol AddTabataTimerListener: AnyObject {
    func addTabataTimerCloseButtonDidTap()
    func addTabataTimerDidAddNewTimer()
}


protocol AddTabataTimerInteractorDependency{
    var timerApplicationService: TimerApplicationService{ get }
    var timerRepository: TimerRepository{ get }
    
    var sectionLists: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>{ get }
    var sectionListsSubject: CurrentValuePublisher<[TimerSectionListModel]>{ get }
}

final class AddTabataTimerInteractor: PresentableInteractor<AddTabataTimerPresentable>, AddTabataTimerInteractable, AddTabataTimerPresentableListener {

    weak var router: AddTabataTimerRouting?
    weak var listener: AddTabataTimerListener?


    private let dependency: AddTabataTimerInteractorDependency
    private var name: String
    
    // in constructor.
    init(
        presenter: AddTabataTimerPresentable,
        dependency: AddTabataTimerInteractorDependency
    ) {
        self.dependency = dependency
        //self.name = dependency.timerType.title
        self.name = "Tabata"
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
  
        let models = [
            TimerSectionListModel(
                id: UUID(),
                emoji: "🔥",
                name: "Ready",
                description: "Before start countdown",
                sequence: 0,
                type: .ready,
                value: .countdown(min: 0, sec: 5)
            ),TimerSectionListModel(
                id: UUID(),
                emoji: "🧘‍♂️",
                name: "Take a rest",
                description: "Take a rest",
                sequence: 1,
                type: .rest,
                value: .countdown(min: 1, sec: 10),
                color: "#3BD2AEff"
            ),TimerSectionListModel(
                id: UUID(),
                emoji: "🧘‍♀️",
                name: "Excercise",
                description: "You can do it!!!",
                sequence: 2,
                type: .exercise,
                value: .countdown(min: 0, sec: 5),
                color: "#3BD2AEff"
            ),
            TimerSectionListModel(
                id: UUID(),
                emoji: "⛳️",
                name: "Round",
                description: "Round is excersise + rest",
                sequence: 3,
                type: .round,
                value: .count(count: 3)
            ),
            TimerSectionListModel(
                id: UUID(),
                emoji: "🔄",
                name: "Cycle",
                description: "Cycle is \(3) round",
                sequence: 4,
                type: .cycle,
                value: .count(count: 3),
                color: "#6200EEFF"
            ),
            TimerSectionListModel(
                id: UUID(),
                emoji: "🧘‍♀️",
                name: "Cycle Rest",
                description: "Take a rest",
                sequence: 5,
                type: .cycleRest,
                value: .countdown(min: 0, sec: 30),
                color: "#6200EEFF"
            ),
            TimerSectionListModel(
                id: UUID(),
                emoji: "❄️",
                name: "Cool Down",
                description: "After excersice cool down",
                sequence: 6,
                type: .cooldown,
                value: .countdown(min: 0, sec: 30)
            )
        ]
        
        dependency.sectionListsSubject.send(models)
        
        router?.attachTimerEditTitle()
        router?.attachTimerSectionList()
        presenter.setTitle(title: "Tabata")
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func closeButtonDidTap() {
        listener?.addTabataTimerCloseButtonDidTap()
    }
    
    func doneButtonDidTap() {
        let createSections = dependency.sectionLists.value.enumerated().map { (sequence, section) in
            CreateSection(
                name: section.name,
                description: section.description,
                sequence: sequence,
                type: section.type.rawValue,
                min: section.value.min,
                sec: section.value.sec,
                count: section.value.count,
                emoji: section.emoji,
                color: section.tint
            )
        }
        
        let createTimer = CreateSectionTimer(
            name: self.name,
            createSections: createSections
        )
        
        
        Task{
            do{
                try await dependency.timerApplicationService.when(createTimer)
                try await dependency.timerRepository.fetchLists()
                await MainActor.run { listener?.addTabataTimerDidAddNewTimer() }
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.message)
                }else{
                    Log.e("UnkownError\n\(error)" )
                }
            }
        }
        
    }
    
    
    //MARK: TimerEditTitle
    func timerEditTitleSetName(name: String) {
        self.name = name
    }
    
    
    //MARK: TimerSectionList
    func timeSectionListDidSelectRowAt(sectionList: TimerSectionListViewModel) {
        router?.attachTimerSectionEdit(sectionList: sectionList)
    }
    
    //MARK: TimerSectionEdit
    func timerSectionEditDidMoved() {
        router?.detachTimerSectionEdit()
    }
    
    

}
