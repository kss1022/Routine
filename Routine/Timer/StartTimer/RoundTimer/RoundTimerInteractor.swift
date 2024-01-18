//
//  RoundTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 1/18/24.
//

import Foundation
import ModernRIBs
import Combine

protocol RoundTimerRouting: ViewableRouting {
    func attachRoundProgress()
    func attachRoundRoundTimer()
    func attachTimerNextSection()
}

protocol RoundTimerPresentable: Presentable {
    var listener: RoundTimerPresentableListener? { get set }
    func setTitle(title: String)
    
    func startLoading()
    func stopLoading()
    
    func showError(title: String, message: String)
    func showCacelError(title: String, message: String)
}

protocol RoundTimerListener: AnyObject {
    func roundTimerDidTapClose()
    func roundTimerDidTapCancel()
    func roundTimerDidCancel()
}

protocol RoundTimerInteractorDependency{
    var roundTimerSubject: CurrentValueSubject<RoundTimerModel?, Error>{ get }
    var timeSubject: CurrentValuePublisher<TimeInterval>{ get }
    var totalSubject: CurrentValuePublisher<TimeInterval>{ get }
    var stateSubject: CurrentValuePublisher<TimerState>{ get }
    var sectionSubject: CurrentValuePublisher<TimeSectionModel?>{ get }
    var progressSubject: CurrentValuePublisher<RoundProgressModel?>{ get }
    var nextSectionSubject: CurrentValuePublisher<TimeSectionModel?>{ get }
}

final class RoundTimerInteractor: PresentableInteractor<RoundTimerPresentable>, RoundTimerInteractable, RoundTimerPresentableListener {
    
    weak var router: RoundTimerRouting?
    weak var listener: RoundTimerListener?
    
    private let dependency: RoundTimerInteractorDependency
    private let timeSubject: CurrentValuePublisher<TimeInterval>
    private let totalSubject: CurrentValuePublisher<TimeInterval>
    private let stateSubject: CurrentValuePublisher<TimerState>
    private let sectionSubject: CurrentValuePublisher<TimeSectionModel?>
    private let progressSubject: CurrentValuePublisher<RoundProgressModel?>
    private let nextSectionSubject: CurrentValuePublisher<TimeSectionModel?>
    private var cancellables: Set<AnyCancellable>
    
    private var model: RoundTimerModel!
    private var timer: RoundBackgroundTimer!
    
    // in constructor.
    init(
        presenter: RoundTimerPresentable,
        dependency: RoundTimerInteractorDependency
    ) {
        self.dependency = dependency
        self.timeSubject = dependency.timeSubject
        self.totalSubject = dependency.totalSubject
        self.stateSubject = dependency.stateSubject
        self.sectionSubject = dependency.sectionSubject
        self.progressSubject = dependency.progressSubject
        self.nextSectionSubject = dependency.nextSectionSubject
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        presenter.startLoading()
        
        dependency.roundTimerSubject
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { error in
                Log.e("\(error)")
                self.showFetchFailed()
            } receiveValue: { model in
                self.model = model
                self.timer = RoundBackgroundTimer(model)
                self.registerTimer()
                self.presenter.stopLoading()
                self.router?.attachRoundProgress()
                self.router?.attachRoundRoundTimer()
                self.router?.attachTimerNextSection()
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
        
        timer.totalTime
            .receive(on: DispatchQueue.main)
            .sink { time in
                self.totalSubject.send(time)
            }
            .store(in: &cancellables)
        
        timer.section
            .receive(on: DispatchQueue.main)
            .sink { section in
                self.sectionSubject.send(section)
            }
            .store(in: &cancellables)
        
        timer.progress
            .receive(on: DispatchQueue.main)
            .sink { progress in
                self.progressSubject.send(progress)
            }
            .store(in: &cancellables)
        
        timer.nextSection
            .receive(on: DispatchQueue.main)
            .sink { next in
                self.nextSectionSubject.send(next)
            }
            .store(in: &cancellables)
        
        timer.completeEvent
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.timerDidFinish()
            }
            .store(in: &cancellables)
        
        sectionSubject.send(model.ready)
        timeSubject.send(model.ready.timeInterval())
    }
    
    
    // MARK: Listener
    func closeButtonDidTap() {
        listener?.roundTimerDidTapClose()
    }
    
    func errorButtonDidTap() {
        self.listener?.roundTimerDidCancel()
    }
    

    //MARK: TabataRoundTimer
    func roundRoundDidTapStart() {
        timer.start()
        stateSubject.send(timer.timerState)
    }
        
    func roundRoundDidTapResume() {
        timer.resume()
        stateSubject.send(timer.timerState)
    }
    
    func roundRoundDidTapPause() {
        timer.suspend()
        stateSubject.send(timer.timerState)
    }
    
    func roundRoundDidTapCancle() {
        timer.cancel()
        listener?.roundTimerDidTapCancel()
    }
    
    func timerDidFinish(){
        // TODO: Record Timer
    }
}


private extension RoundTimerInteractor{
    func showFetchFailed(){
        let title = "error".localized(tableName: "Timer")
        let message = "fetch_timer_failed".localized(tableName: "Timer")
        presenter.showCacelError(title: title, message: message)
    }
}
