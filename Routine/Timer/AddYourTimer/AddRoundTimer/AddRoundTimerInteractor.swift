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
    func showError(title: String, message: String)
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
        self.name = ""
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
  
        let models = TimerSetup().roundSectionLists()
        
        dependency.sectionListsSubject.send(models)
        
        router?.attachTimerEditTitle()
        router?.attachTimerSectionList()
        presenter.setTitle(title: "round".localized(tableName: "Timer"))
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
        
        
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.timerApplicationService.when(createTimer)
                try await dependency.timerRepository.fetchLists()
                await MainActor.run { [weak self] in self?.listener?.addRoundTimerDidAddNewTimer() }
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


private extension AddRoundTimerInteractor{
    @MainActor
    func showAddTimerFailed(){
        let title = "oops".localized(tableName: "Timer")
        let message = "add_timer_failed".localized(tableName: "Timer")
        presenter.showError(title: title, message: message)
    }
    
    @MainActor
    func showSystemFailed(){
        let title = "error".localized(tableName: "Timer")
        let message = "sorry_there_are_proble_with_request".localized(tableName: "Timer")
        presenter.showError(title: title, message: message)
    }
}
