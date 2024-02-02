//
//  AddFocusTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/30/23.
//

import ModernRIBs

protocol AddFocusTimerRouting: ViewableRouting {
    func attachTimerEditTitle(name: String, emoji: String)
    func attachTimerEditMinutes(minutes: Int)
}

protocol AddFocusTimerPresentable: Presentable {
    var listener: AddFocusTimerPresentableListener? { get set }
    func setTitle(title: String)
    func showError(title: String, message: String)
}

protocol AddFocusTimerListener: AnyObject {
    func addFocusTimerCloseButtonDidTap()
    func addfocusTimerDidAddNewTimer()
}

protocol AddFocusTimerInteractorDependency{
    var timerApplicationService: TimerApplicationService{ get }
    var timerRepository: TimerRepository{ get }
}

final class AddFocusTimerInteractor: PresentableInteractor<AddFocusTimerPresentable>, AddFocusTimerInteractable, AddFocusTimerPresentableListener {


    weak var router: AddFocusTimerRouting?
    weak var listener: AddFocusTimerListener?
    
    private let dependency: AddFocusTimerInteractorDependency

    private var name: String
    private var emoji: String
    private var minutes: Int
    
    
    // in constructor.
    init(
        presenter: AddFocusTimerPresentable,
        dependency: AddFocusTimerInteractorDependency
    ) {
        self.dependency = dependency
        self.name = ""
        self.emoji = "🍅"
        self.minutes = 30
        
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachTimerEditTitle(name: name, emoji: emoji)
        router?.attachTimerEditMinutes(minutes: minutes)
    }

    override func willResignActive() {
        super.willResignActive()
    }
    

    
    func closeButtonDidTap() {
        listener?.addFocusTimerCloseButtonDidTap()
    }
    
    func doneButtonDidTap() {
        let styles = EmojiService().styles()
        let tint = styles[Int.random(in: 0..<(styles.count))]
        
        let createTimer = CreateFocusTimer(
            name: name,
            emoji: emoji,
            tint: tint.hex,
            min: minutes
        )
                
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.timerApplicationService.when(createTimer)
                try await dependency.timerRepository.fetchLists()
                await MainActor.run { [weak self] in self?.listener?.addfocusTimerDidAddNewTimer() }
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.message)
                    await showAddTimerFailed()
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


private extension AddFocusTimerInteractor{
    
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
