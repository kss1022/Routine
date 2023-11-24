//
//  AddRoundTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/30/23.
//

import ModernRIBs
import Foundation

protocol AddRoundTimerRouting: ViewableRouting {
    func attachTimerSectionEdit(sectionList: TimerSectionListViewModel)
    func detachTimerSectionEdit()
    
    func attachTimerEditTitle()
    func attachTimerSectionList()
}

protocol AddRoundTimerPresentable: Presentable {
    var listener: AddRoundTimerPresentableListener? { get set }
    func setTitle(title: String)
}

protocol AddRoundTimerListener: AnyObject {
    func addRoundTimerCloseButtonDidTap()
    func addRoundTimerDidAddNewTimer()
}

protocol AddRoundTimerInteractorDependency{
    var timerApplicationService: TimerApplicationService{ get }
    var timerRepository: TimerRepository{ get }
    
    var sectionLists: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>{ get }
    var sectionListsSubject: CurrentValuePublisher<[TimerSectionListModel]>{ get }
}


final class AddRoundTimerInteractor: PresentableInteractor<AddRoundTimerPresentable>, AddRoundTimerInteractable, AddRoundTimerPresentableListener {

    weak var router: AddRoundTimerRouting?
    weak var listener: AddRoundTimerListener?
  
    private let dependency: AddRoundTimerInteractorDependency
    private var name: String
    
    // in constructor.
    init(
        presenter: AddRoundTimerPresentable,
        dependency: AddRoundTimerInteractorDependency
    ) {
        self.dependency = dependency
        //self.name = dependency.timerType.title
        self.name = "Round"
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
                emoji: "🏃‍♂️",
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
        presenter.setTitle(title: "Round")
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func closeButtonDidTap() {
        listener?.addRoundTimerCloseButtonDidTap()
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
                await MainActor.run { listener?.addRoundTimerDidAddNewTimer() }
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
