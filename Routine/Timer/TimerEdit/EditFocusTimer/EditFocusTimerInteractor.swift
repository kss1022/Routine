//
//  EditFocusTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 1/15/24.
//

import Foundation
import ModernRIBs
import Combine

protocol EditFocusTimerRouting: ViewableRouting {
    func attachTimerEditTitle(name: String, emoji: String)
    func attachTimerEditMinutes(minutes: Int)
}

protocol EditFocusTimerPresentable: Presentable {
    var listener: EditFocusTimerPresentableListener? { get set }
    func setTitle(title: String)
    
    func startLoading()
    func stopLoading()
    
    func showError(title: String, message: String)
    func showCacelError(title: String, message: String)
}

protocol EditFocusTimerListener: AnyObject {
    func editFocusTimerDidTapClose()
    func editfocusTimerDidEditTimer()
    func editfocusTimerCancel()
}

protocol EditFocusTimerInteractorDependency{
    var timerApplicationService: TimerApplicationService{ get }
    var timerRepository: TimerRepository{ get }
    var focusTimerSubject: CurrentValueSubject<FocusTimerModel?, Error>{ get }
}

final class EditFocusTimerInteractor: PresentableInteractor<EditFocusTimerPresentable>, EditFocusTimerInteractable, EditFocusTimerPresentableListener {

    weak var router: EditFocusTimerRouting?
    weak var listener: EditFocusTimerListener?
    
    private var dependency: EditFocusTimerInteractorDependency
    private let timerApplicatoinService: TimerApplicationService
    private let timerRepository: TimerRepository
    private let timerSubject: CurrentValueSubject<FocusTimerModel?, Error>
    
    private var cancellables: Set<AnyCancellable>
    
    private var id: UUID!
    private var name: String!
    private var emoji: String!
    private var tint: String!
    private var minutes: Int!
    

    
    // in constructor.
    init(
        presenter: EditFocusTimerPresentable,
        dependency: EditFocusTimerInteractorDependency
    ) {
        self.dependency = dependency
        self.timerApplicatoinService = dependency.timerApplicationService
        self.timerRepository = dependency.timerRepository
        self.timerSubject = dependency.focusTimerSubject
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        self.presenter.startLoading()
        timerSubject
            .receive(on: DispatchQueue.main)
            .compactMap{ $0 }
            .sink { error in
                Log.e("\(error)")
                self.showFetchFailed()
                self.listener?.editfocusTimerCancel()
            } receiveValue: { model in
                self.id = model.id
                self.name = model.name
                self.emoji = model.emoji
                self.minutes = model.minutes                                                
                self.tint = model.tint
                self.presenter.stopLoading()
                self.router?.attachTimerEditTitle(name: self.name, emoji: self.emoji)
                self.router?.attachTimerEditMinutes(minutes: self.minutes)
            }
            .store(in: &cancellables)                    
    }

    override func willResignActive() {
        super.willResignActive()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func closeButtonDidTap() {
        listener?.editFocusTimerDidTapClose()
    }
    
    func errorButtonDidTap() {
        self.listener?.editfocusTimerCancel()
    }
    
    func doneButtonDidTap() {
        let createTimer = UpdateFocusTimer(
            id: id,
            name: name,
            emoji: emoji,
            tint: tint,
            min: minutes
        )
                
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.timerApplicationService.when(createTimer)
                try await dependency.timerRepository.fetchLists()
                await MainActor.run { [weak self] in self?.listener?.editfocusTimerDidEditTimer() }
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.message)
                    await showUpdateTimerFailed()
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
    
    
    //MARK: TimerEditCountdown
    
    func timerEditMinutesSetMinutes(minute: Int) {
        self.minutes = minute
    }
}


private extension EditFocusTimerInteractor{
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
}
