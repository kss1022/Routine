//
//  AddRoundTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/30/23.
//

import ModernRIBs
import Foundation

protocol AddRoundTimerRouting: ViewableRouting {
    func attachTimerSectionEdit(sectionList: TimerSectionListModel)
    func detachTimerSectionEdit()
    
    func attachTimerEditTitle(name: String, emoji: String)
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
    var timerRecordRepository: TimerRecordRepository{ get }
    
    var sectionLists: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>{ get }
    var sectionListsSubject: CurrentValuePublisher<[TimerSectionListModel]>{ get }
}


final class AddRoundTimerInteractor: PresentableInteractor<AddRoundTimerPresentable>, AddRoundTimerInteractable, AddRoundTimerPresentableListener {

    weak var router: AddRoundTimerRouting?
    weak var listener: AddRoundTimerListener?
  
    private let dependency: AddRoundTimerInteractorDependency
    
    private var name: String
    private var emoji: String
    private var roundSectionListModel: RoundSectionListsModel
    
    // in constructor.
    init(
        presenter: AddRoundTimerPresentable,
        dependency: AddRoundTimerInteractorDependency
    ) {
        self.dependency = dependency
        self.name = ""
        self.emoji = "🍅"
        
        let timerSetup = TimerSetup()
        self.roundSectionListModel = RoundSectionListsModel(
            ready: timerSetup.ready(),
            exercise: timerSetup.exercise(),
            rest: timerSetup.rest(),
            round: timerSetup.round(),
            cooldown: timerSetup.cooldown()
        )
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
  
        let sectionLists =  self.roundSectionListModel.sectionLists()
        dependency.sectionListsSubject.send(sectionLists)
        
        router?.attachTimerEditTitle(name: name, emoji: emoji)
        router?.attachTimerSectionList()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func closeButtonDidTap() {
        listener?.addRoundTimerCloseButtonDidTap()
    }
    
    func doneButtonDidTap() {
        let styles = EmojiService().styles()
        let tint = styles[Int.random(in: 0..<(styles.count))]
                
        
        let sectionLists = dependency.sectionLists.value
        let command = CreateRoundTimer(
            name: name,
            emoji: emoji,
            tint: tint.hex,
            ready: TimeSectionCommand(sectionLists[0].toTimeSectionModel()),
            exercise: TimeSectionCommand(sectionLists[1].toTimeSectionModel()),
            rest: TimeSectionCommand(sectionLists[2].toTimeSectionModel()),
            round: RepeatSectionCommand(sectionLists[3].toRepeatSectionModel()),
            cooldown: TimeSectionCommand(sectionLists[4].toTimeSectionModel())
        )
        
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.timerApplicationService.when(command)
                try await dependency.timerRepository.fetchLists()
                try await dependency.timerRecordRepository.fetchList()
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
