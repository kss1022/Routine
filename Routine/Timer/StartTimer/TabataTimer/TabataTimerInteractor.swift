//
//  TabataTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import Foundation
import ModernRIBs
import Combine

protocol TabataTimerRouting: ViewableRouting {
    func attachTabataProgress()
    func attachTabataRoundTimer()
    func attachTimerNextSection()
}

protocol TabataTimerPresentable: Presentable {
    var listener: TabataTimerPresentableListener? { get set }
    func setTitle(title: String)
    
    func startLoading()
    func stopLoading()
    
    func showError(title: String, message: String)
    func showCacelError(title: String, message: String)
}

protocol TabataTimerListener: AnyObject {
    func tabataTimerDidTapClose()
    func tabataTimerDidTapCancel()
    func tabataTimerDidCancel()
}

protocol TabataTimerInteractorDependency{
    var tabataTimerSubject: CurrentValueSubject<TabataTimerModel?, Error>{ get }
    var timeSubject: CurrentValuePublisher<TimeInterval>{ get }
    var totalSubject: CurrentValuePublisher<TimeInterval>{ get }
    var stateSubject: CurrentValuePublisher<TimerState>{ get }
    var sectionSubject: CurrentValuePublisher<TimeSectionModel?>{ get }
    var progressSubject: CurrentValuePublisher<TabataProgressModel?>{ get }
    var nextSectionSubject: CurrentValuePublisher<TimeSectionModel?>{ get }
}

final class TabataTimerInteractor: PresentableInteractor<TabataTimerPresentable>, TabataTimerInteractable, TabataTimerPresentableListener {

    weak var router: TabataTimerRouting?
    weak var listener: TabataTimerListener?

    private let dependency: TabataTimerInteractorDependency
    private let timeSubject: CurrentValuePublisher<TimeInterval>
    private let totalSubject: CurrentValuePublisher<TimeInterval>
    private let stateSubject: CurrentValuePublisher<TimerState>
    private let sectionSubject: CurrentValuePublisher<TimeSectionModel?>
    private let progressSubject: CurrentValuePublisher<TabataProgressModel?>
    private let nextSectionSubject: CurrentValuePublisher<TimeSectionModel?>
    private var cancellables: Set<AnyCancellable>

    private var model: TabataTimerModel!
    private var timer: TabataBackgroundTimer!
    
    
    // in constructor.
    init(
        presenter: TabataTimerPresentable,
        dependency: TabataTimerInteractorDependency
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
        
        dependency.tabataTimerSubject
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { error in
                Log.e("\(error)")
                self.showFetchFailed()
            } receiveValue: { model in
                self.model = model
                self.timer = TabataBackgroundTimer(model)
                self.registerTimer()
                self.presenter.stopLoading()
                self.router?.attachTabataProgress()
                self.router?.attachTabataRoundTimer()
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
        listener?.tabataTimerDidTapClose()
    }
    
    func errorButtonDidTap() {
        self.listener?.tabataTimerDidCancel()
    }
    

    //MARK: TabataRoundTimer
    func tabataRoundDidTapStart() {
        timer.start()
        stateSubject.send(timer.timerState)
    }
        
    func tabataRoundDidTapResume() {
        timer.resume()
        stateSubject.send(timer.timerState)
    }
    
    func tabataRoundDidTapPause() {
        timer.suspend()
        stateSubject.send(timer.timerState)
    }
    
    func tabataRoundDidTapCancle() {
        timer.cancel()
        listener?.tabataTimerDidTapCancel()
    }
    
    func timerDidFinish(){
        // TODO: Record Timer
    }
}


private extension TabataTimerInteractor{
    func showFetchFailed(){
        let title = "error".localized(tableName: "Timer")
        let message = "fetch_timer_failed".localized(tableName: "Timer")
        presenter.showCacelError(title: title, message: message)
    }
}

