//
//  AddTabataTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/30/23.
//

import Foundation
import ModernRIBs

protocol AddTabataTimerRouting: ViewableRouting {
    func attachTimerSectionEdit(sectionList: TimerSectionListModel)
    func detachTimerSectionEdit()
    
    func attachTimerEditTitle(name: String, emoji: String)
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
    private var tabatSectionListModel: TabataSectionListsModel

    // in constructor.
    init(
        presenter: AddTabataTimerPresentable,
        dependency: AddTabataTimerInteractorDependency
    ) {
        self.dependency = dependency
        self.name = ""
        self.emoji = "🍅"
        
        let timerSetup = TimerSetup()
        self.tabatSectionListModel = TabataSectionListsModel(
            ready: timerSetup.ready(),
            exercise: timerSetup.exercise(),
            rest: timerSetup.rest(),
            round: timerSetup.round(),
            cycle: timerSetup.cycle(),
            cycleRest: timerSetup.cycleRest(),
            cooldown: timerSetup.cooldown()
        )
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        let sectionLists =  self.tabatSectionListModel.sectionLists()
        dependency.sectionListsSubject.send(sectionLists)
  
        router?.attachTimerEditTitle(name: name, emoji: emoji)
        router?.attachTimerSectionList()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func closeButtonDidTap() {
        listener?.addTabataTimerCloseButtonDidTap()
    }
    
    func doneButtonDidTap() {
        let styles = EmojiService().styles()
        let tint = styles[Int.random(in: 0..<(styles.count))]
                
        
        let sectionLists = dependency.sectionLists.value                
        let command = CreateTabataTimer(
            name: name,
            emoji: emoji,
            tint: tint.hex,
            ready: TimeSectionCommand(sectionLists[0].toTimeSectionModel()),
            exercise: TimeSectionCommand(sectionLists[1].toTimeSectionModel()),
            rest: TimeSectionCommand(sectionLists[2].toTimeSectionModel()),
            round: RepeatSectionCommand(sectionLists[3].toRepeatSectionModel()),
            cycle: RepeatSectionCommand(sectionLists[4].toRepeatSectionModel()),
            cycleRest: TimeSectionCommand(sectionLists[5].toTimeSectionModel()),
            cooldown: TimeSectionCommand(sectionLists[6].toTimeSectionModel())
        )
               
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.timerApplicationService.when(command)
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
    func timeSectionListDidTap(sectionList: TimerSectionListModel) {
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
