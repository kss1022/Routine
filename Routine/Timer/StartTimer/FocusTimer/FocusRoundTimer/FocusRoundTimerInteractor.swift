//
//  FocusRoundTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import Foundation
import ModernRIBs
import Combine

protocol FocusRoundTimerRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol FocusRoundTimerPresentable: Presentable {
    var listener: FocusRoundTimerPresentableListener? { get set }
    
    func setTimer(_ viewModel: FocusRoundTimerViewModel)
    
    func showStartButton()
    func showPauseButton()
    func showResumeButton()
    func showTimerActionDialog()
    func updateRemainTime(time: String)
    
    func startProgress(totalDuration: TimeInterval)
    func updateProgress(from: CGFloat,  remainDuration: TimeInterval)    //for restart
    func resumeProgress()
    func suspendProgress()
}

protocol FocusRoundTimerListener: AnyObject {
    func focusRoundTimerDidStartTimer(startAt: Date)
    func focusRoundTimerDidResume()
    func focusRoundTimerDidSuspend()
    func focusRoundTimerDidTapCancle()
    func focusRoundTimerDidFinish(startAt: Date, endAt: Date, duration: Double)
}

protocol FocusRoundTimerInteractorDependency{
    var model: TimerFocusModel{ get }
    var timer: AppFocusTimer{ get }
}

final class FocusRoundTimerInteractor: PresentableInteractor<FocusRoundTimerPresentable>, FocusRoundTimerInteractable, FocusRoundTimerPresentableListener {

    weak var router: FocusRoundTimerRouting?
    weak var listener: FocusRoundTimerListener?

    private let dependency : FocusRoundTimerInteractorDependency
    private var cancellables: Set<AnyCancellable>

    private let timer: AppFocusTimer
    private let model: TimerFocusModel
    
    // in constructor.
    init(
        presenter: FocusRoundTimerPresentable,
        dependency: FocusRoundTimerInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        self.timer = dependency.timer
        self.model = dependency.model
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()

        
        self.setTimer()
        
        self.timer.remainTime
            .receive(on: DispatchQueue.main)
            .sink { _ in
                let remainTime = self.timer.remainTime.value
                
                if remainTime != -1{
                    self.presenter.updateRemainTime(time: remainTime.focusTime)
                }
            }
            .store(in: &cancellables)
        
        self.timer.completeEvent
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.listener?.focusRoundTimerDidFinish(
                    startAt: self.timer.startAt!,
                    endAt: Date(),
                    duration: self.timer.totalTime - self.timer.remainTime.value
                )
                
                self.removeTimer()
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        
        if timer.timerState == .initialized{
            removeTimer()
        }
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    

    
    func roundTimerDidTap() {
        switch timer.timerState {
        case .initialized:  //set start
            timer.start()
            presenter.showPauseButton()
            presenter.startProgress(totalDuration: timer.totalTime)
            listener?.focusRoundTimerDidStartTimer(startAt: timer.startAt!)
        case .resumed:      //set suspend
            timer.suspend()
            presenter.showResumeButton()
            presenter.suspendProgress()
            listener?.focusRoundTimerDidSuspend()
        case .suspended:    //set resume
            timer.resume()
            presenter.showPauseButton()
            presenter.resumeProgress()
            listener?.focusRoundTimerDidResume()
        default: break //cancel
        }
    }
    
    func roundTimerLongPress() {
        if timer.timerState != .initialized{
            presenter.showTimerActionDialog()
        }
    }
    
    func cancelButtonDidTap() {
        if timer.timerState != .initialized{
            timer.cancel()
            presenter.suspendProgress()
            removeTimer()
            listener?.focusRoundTimerDidTapCancle()
        }else{
            listener?.focusRoundTimerDidTapCancle()
        }
    }
    
    
    
    func finishButtonDidTap() {
        if timer.timerState != .initialized{
            timer.cancel()
            presenter.suspendProgress()
            listener?.focusRoundTimerDidFinish(
                startAt: self.timer.startAt!,
                endAt: Date(),
                duration: self.timer.totalTime - self.timer.remainTime.value
            )
            
            removeTimer()
        }else{
            listener?.focusRoundTimerDidTapCancle()
        }
    }
    
    

    
    
    // MARK: Private
    
    
    private func setTimer(){
        
        presenter.setTimer(FocusRoundTimerViewModel(self.model))
        
        switch timer.timerState {
        case .initialized:
            presenter.showStartButton()
        case .resumed:
            updateProgress()
            presenter.showPauseButton()
            presenter.resumeProgress()
            listener?.focusRoundTimerDidResume()
        case .suspended:
            updateProgress()
            presenter.showResumeButton()
            presenter.suspendProgress()
            listener?.focusRoundTimerDidSuspend()
        case .canceled:
            //TODO: Show Cancel State
            presenter.showStartButton()
        }
    }
    
    
    private func updateProgress(){
        let remainDuration = timer.remainTime.value
        let progress = remainDuration / timer.totalTime
        presenter.updateProgress(from: progress, remainDuration: remainDuration)
    }
    
    private func removeTimer(){
        AppTimerManager.shared.removeTimer(id: model.timerId)
    }

}
