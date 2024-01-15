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
    func showError(title: String, message: String)
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
    private var emoji: String
    
    // in constructor.
    init(
        presenter: AddTabataTimerPresentable,
        dependency: AddTabataTimerInteractorDependency
    ) {
        self.dependency = dependency
        //self.name = dependency.timerType.title
        self.name = ""
        self.emoji = "🍅"
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
  
        let models = TimerSetup().tabataSectionsLists()
        
        dependency.sectionListsSubject.send(models)
        
        router?.attachTimerEditTitle()
        router?.attachTimerSectionList()
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
        
        let styles = EmojiService().styles()
        var tint = styles[Int.random(in: 0..<(styles.count))]
        
        let createTimer = CreateSectionTimer(
            name: name,
            emoji: emoji,
            tint: tint.hex,
            timerType: TimerTypeModel.tabata.rawValue,
            createSections: createSections
        )
        
        
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.timerApplicationService.when(createTimer)
                try await dependency.timerRepository.fetchLists()
                await MainActor.run { [weak self] in self?.listener?.addTabataTimerDidAddNewTimer() }
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.message)
                    await showAddTimerFailed()
                }else{
                    Log.e("UnkownError\n\(error)" )
                    await showSystemFailed()
                }
            }
        }
        
    }
    
    
    //MARK: TimerEditTitle
    func timerEditTitleDidSetName(name: String) {
        self.name = name
        presenter.setTitle(title: name)
    }
    
    func timerEditTitleDidSetEmoji(emoji: String) {
        self.emoji = emoji
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


private extension AddTabataTimerInteractor{
    
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
