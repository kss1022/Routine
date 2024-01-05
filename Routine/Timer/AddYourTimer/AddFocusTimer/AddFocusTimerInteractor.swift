//
//  AddFocusTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/30/23.
//

import ModernRIBs

protocol AddFocusTimerRouting: ViewableRouting {
    func attachTimerEditTitle()
    func attachTimerEditCountdown()
}

protocol AddFocusTimerPresentable: Presentable {
    var listener: AddFocusTimerPresentableListener? { get set }
    func setTitle(title: String)
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
    private var minute: Int
    // in constructor.
    init(
        presenter: AddFocusTimerPresentable,
        dependency: AddFocusTimerInteractorDependency
    ) {
        self.dependency = dependency
        self.name = "focus".localized(tableName: "Timer")
        self.minute = 30
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachTimerEditTitle()
        router?.attachTimerEditCountdown()
        presenter.setTitle(title: "focus".localized(tableName: "Timer"))
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    

    
    func closeButtonDidTap() {
        listener?.addFocusTimerCloseButtonDidTap()
    }
    
    func doneButtonDidTap() {
        let createTimer = CreateFocusTimer(name: self.name, min: self.minute)
        
        
        Task{
            do{
                try await dependency.timerApplicationService.when(createTimer)
                try await dependency.timerRepository.fetchLists()
                await MainActor.run { listener?.addfocusTimerDidAddNewTimer() }
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
    
    //MARK: TimerEditCountdown
    
    func timerEditCountdownSetMinute(minute: Int) {
        self.minute = minute
    }
    
}
