//
//  EditTabataTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 1/16/24.
//

import Foundation
import ModernRIBs
import Combine

protocol EditTabataTimerRouting: ViewableRouting {
    func attachTimerSectionEdit(sectionList: TimerSectionListModel)
    func detachTimerSectionEdit()
    
    func attachTimerEditTitle(name: String, emoji: String)
    func attachTimerSectionList()
}

protocol EditTabataTimerPresentable: Presentable {
    var listener: EditTabataTimerPresentableListener? { get set }
    func setTitle(title: String)
    
    func startLoading()
    func stopLoading()
    
    
    func showError(title: String, message: String)
    func showCacelError(title: String, message: String)
}

protocol EditTabataTimerListener: AnyObject {
    func editTabataTimerDidClose()
    func editTabataTimerDidEdit()
    func editTabataTimerDidDelete()
    func editTabataTimerDidCancel()
}

protocol EditTabataTimerInteractorDependency{
    var timerApplicationService: TimerApplicationService{ get }
    var timerRepository: TimerRepository{ get }
    var timerRecordRepository: TimerRecordRepository{ get }
    
    var tabataTimerSubject: CurrentValueSubject<TabataTimerModel?, Error>{ get }
    
    var sectionLists: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>{ get }
    var sectionListsSubject: CurrentValuePublisher<[TimerSectionListModel]>{ get }
}


final class EditTabataTimerInteractor: PresentableInteractor<EditTabataTimerPresentable>, EditTabataTimerInteractable, EditTabataTimerPresentableListener {

    weak var router: EditTabataTimerRouting?
    weak var listener: EditTabataTimerListener?

    private let dependency: EditTabataTimerInteractorDependency
    private let timerApplicationService: TimerApplicationService
    private let timerRepository: TimerRepository
    
    private var cancellables: Set<AnyCancellable>
    
    private var id: UUID!
    private var name: String!
    private var emoji: String!
    private var tint: String!
    private var tabatSectionListModel: TabataSectionListsModel!
    
    // in constructor.
    init(
        presenter: EditTabataTimerPresentable,
        dependency: EditTabataTimerInteractorDependency
    ) {
        self.dependency = dependency
        self.timerApplicationService = dependency.timerApplicationService
        self.timerRepository = dependency.timerRepository
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        self.presenter.startLoading()
        
        dependency.tabataTimerSubject
            .compactMap{ $0 }
            .receive(on: DispatchQueue.main)            
            .sink { error in
                Log.e("\(error)")
                self.showFetchFailed()                
            } receiveValue: { model in
                self.id = model.id
                self.name = model.name
                self.emoji = model.emoji
                self.tint = model.tint
                

                self.tabatSectionListModel = TabataSectionListsModel(
                    ready: model.ready,
                    exercise: model.exercise,
                    rest: model.rest,
                    round: model.round,
                    cycle: model.cycle,
                    cycleRest: model.cycleRest,
                    cooldown: model.cooldown
                )
                self.presenter.stopLoading()
                self.dependency.sectionListsSubject.send(self.tabatSectionListModel.sectionLists())
                self.router?.attachTimerEditTitle(name: self.name, emoji: self.emoji)
                self.router?.attachTimerSectionList()
            }
            .store(in: &cancellables)

        
    }

    override func willResignActive() {
        super.willResignActive()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func closeButtonDidTap() {
        listener?.editTabataTimerDidClose()
    }
        
    func errorButtonDidTap() {
        self.listener?.editTabataTimerDidCancel()
    }
    
    func doneButtonDidTap() {
        let sectionLists = dependency.sectionLists.value
        let command = UpdateTabataTimer(
            id: id,
            name: name,
            emoji: emoji,
            tint: tint,
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
                try await dependency.timerRecordRepository.fetchList()
                await MainActor.run { [weak self] in self?.listener?.editTabataTimerDidEdit() }
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.message)
                    await showUpdateTimerFailed()
                }else{
                    Log.e("UnkownError\n\(error)" )
                    //await showSystemFailed()
                }
            }
        }
        
    }
    
    
    func deleteButtonDidTap() {
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                let deleteTimer = DeleteTabataTimer(id: id)
                try await dependency.timerApplicationService.when(deleteTimer)
                try await dependency.timerRepository.fetchLists()
                try await dependency.timerRecordRepository.fetchList()
                await MainActor.run { [weak self] in self?.listener?.editTabataTimerDidDelete() }
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.message)
                    await showDeleteFailed()
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



private extension EditTabataTimerInteractor{
    
    @MainActor
    func showUpdateTimerFailed(){
        let title = "oops".localized(tableName: "Timer")
        let message = "update_timer_failed".localized(tableName: "Timer")
        presenter.showError(title: title, message: message)
    }
    
    func showFetchFailed(){
        let title = "error".localized(tableName: "Timer")
        let message = "fetch_timer_failed".localized(tableName: "Timer")
        presenter.showCacelError(title: title, message: message)
    }
    
    @MainActor
    func showDeleteFailed(){
        let title = "error".localized(tableName: "Timer")
        let message = "delete_timer_failed".localized(tableName: "Timer")
        presenter.showError(title: title, message: message)
    }
}
