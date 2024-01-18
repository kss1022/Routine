//
//  FocusTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import Foundation
import ModernRIBs
import Combine

protocol FocusTimerRouting: ViewableRouting {
    func attachFocusRoundTimer()
}

protocol FocusTimerPresentable: Presentable {
    var listener: FocusTimerPresentableListener? { get set }
    func setTitle(title: String)
    
    func setResume()
    func setSuspend()
    func setFinish()
        
    func showActionDialog()
    
    func startLoading()
    func stopLoading()
    
    func showError(title: String, message: String)
    func showCacelError(title: String, message: String)
}

protocol FocusTimerListener: AnyObject {
    func focusTimerDidCancel()
    func focusTimerDidTapClose()
    func focusTimerDidTapCancel()
    
}

protocol FocusTimerInteractorDependency{
    var recordApplicationService: RecordApplicationService{ get }
    var timerRepository: TimerRepository{ get }
    
    
    var focusTimerSubject: CurrentValueSubject<FocusTimerModel?, Error>{ get }
    var timeSubject: CurrentValuePublisher<TimeInterval>{ get }
    var stateSubject: CurrentValuePublisher<TimerState>{ get }
}

final class FocusTimerInteractor: PresentableInteractor<FocusTimerPresentable>, FocusTimerInteractable, FocusTimerPresentableListener {

    weak var router: FocusTimerRouting?
    weak var listener: FocusTimerListener?
    
    private let dependency: FocusTimerInteractorDependency
    private let recordApplicationService: RecordApplicationService
    private let timerRepository: TimerRepository
    
    private let timeSubject: CurrentValuePublisher<TimeInterval>
    private let stateSubject: CurrentValuePublisher<TimerState>
    private var cancellables: Set<AnyCancellable>
    
    private var model: FocusTimerModel!
    private var timer: BaseTimer!
    
    
    
    
    
    // in constructor.
    init(
        presenter: FocusTimerPresentable,
        dependency: FocusTimerInteractorDependency
    ) {
        self.dependency = dependency
        self.recordApplicationService = dependency.recordApplicationService
        self.timerRepository = dependency.timerRepository
        self.timeSubject = dependency.timeSubject
        self.stateSubject = dependency.stateSubject
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        
        dependency.focusTimerSubject
            .compactMap{ $0 }
            .receive(on: DispatchQueue.main)            
            .sink { error in
                Log.e("\(error)")
                self.showFetchFailed()
            } receiveValue: { model in
                self.model = model
                
                let minutes = TimeInterval(model.minutes).minutes
                self.timer = FocusBackgroundTimer(minutes)
                self.registerTimer()
                self.presenter.stopLoading()
                self.router?.attachFocusRoundTimer()
                self.presenter.setTitle(title: model.name)
            }
            .store(in: &cancellables)
                        
    }

    override func willResignActive() {
        super.willResignActive()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    
    private func registerTimer(){
        timer.remainTime
            .receive(on: DispatchQueue.main)
            .sink { time in
                self.timeSubject.send(time)
            }
            .store(in: &cancellables)

        
        timer.completeEvent
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.timerDidFinish()
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: Listener
    func closeButtonDidTap() {
        listener?.focusTimerDidTapClose()
    }
    
    func errorButtonDidTap() {
        listener?.focusTimerDidCancel()
    }
    
    func finishButtonDidTap() {
        timer.cancel()
        timer.complete()
    }
    
    func cancelButtonDidTap() {
        timer.cancel()
        listener?.focusTimerDidTapCancel()
    }
    
    // MARK: FocusRoundTimer
    func foucsRoundTimerDidTapTimer() {
        switch timer.timerState {
        case .initialized:
            timer.start()
            presenter.setResume()
        case .suspended:
            timer.resume()
            presenter.setResume()
        case .resumed:
            timer.suspend()
            presenter.setSuspend()
        case .canceled: break
        }
        
        stateSubject.send(timer.timerState)
    }
    
    func focusRoundTimerDidLongPressTimer() {
        if timer.timerState == .initialized || timer.timerState == .canceled{
            return
        }
        presenter.showActionDialog()
    }
    

    func timerDidFinish(){
        // TODO: Record Timer
        presenter.setFinish()
    }
}

private extension FocusTimerInteractor{
    func showFetchFailed(){
        let title = "error".localized(tableName: "Timer")
        let message = "fetch_timer_failed".localized(tableName: "Timer")
        presenter.showCacelError(title: title, message: message)
    }
}

