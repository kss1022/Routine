//
//  CircularTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation
import ModernRIBs
import Combine

protocol CircularTimerRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CircularTimerPresentable: Presentable {
    var listener: CircularTimerPresentableListener? { get set }
    
    func setTimer(_ viewModel: CircularTimerViewModel)
    
    func showStartButton()
    func showPauseButton()
    func showResumeButton()
    
    func updateRemainTime(time: String)
    
    func startProgress(totalDuration: TimeInterval)
    func updateProgress(from: CGFloat,  remainDuration: TimeInterval)    //for restart
    func resumeProgress()
    func suspendProgress()
}

protocol CircularTimerListener: AnyObject {
    func circularTimerDidTapCancle()
}

protocol CircularTimerInteractorDependency{
    var timer: AppTimer{ get }
    var detail: TimerSectionsModel{ get }
}

final class CircularTimerInteractor: PresentableInteractor<CircularTimerPresentable>, CircularTimerInteractable, CircularTimerPresentableListener {

    weak var router: CircularTimerRouting?
    weak var listener: CircularTimerListener?

    private let dependency : CircularTimerInteractorDependency
    private var cancellables: Set<AnyCancellable>

    private let timer: AppTimer
    private let detail: TimerSectionsModel
    
    // in constructor.
    init(
        presenter: CircularTimerPresentable,
        dependency: CircularTimerInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()        
        self.timer = dependency.timer
        self.detail = dependency.detail
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()

        
        self.setTimer(section: timer.sectionState.value)                
        self.checkExistTimer()
        
        self.timer.remainTime
            .receive(on: DispatchQueue.main)
            .sink { _ in
                let remainTime = self.timer.remainTime.value
                
                if remainTime != -1{
                    self.presenter.updateRemainTime(time: remainTime.time)
                }
            }
            .store(in: &cancellables)
        
        self.timer.completeEvent
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.removeTimer()
                                
                if self.timer.remainTime.value > 0 {
                    self.listener?.circularTimerDidTapCancle()
                }else{
                    // TODO: Set Timer Finish
                }
            }
            .store(in: &cancellables)
        
        self.timer.sectionState
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { section in
                self.setTimer(section: section)
                self.presenter.startProgress(totalDuration: self.timer.totalTime)
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
    

    
    func activeButtonDidTap() {
        switch timer.timerState {
        case .initialized:            
            timer.start()
            presenter.showPauseButton()
            presenter.startProgress(totalDuration: timer.totalTime)
        case .resumed:
            timer.suspend()
            presenter.showResumeButton()
            presenter.suspendProgress()
        case .suspended:
            timer.resume()
            presenter.showPauseButton()
            presenter.resumeProgress()
        default: break //cancel
        }
    }
    
    func cancelButtonDidTap() {
        if timer.timerState != .initialized{
            timer.cancel()
            presenter.suspendProgress()
        }
    }
    
    
    
    
    private func checkExistTimer(){
        switch timer.timerState {
        case .initialized:
            presenter.showStartButton()
        case .resumed:
            updateProgress()
            presenter.showPauseButton()
            presenter.resumeProgress()
        case .suspended:
            updateProgress()
            presenter.showResumeButton()
            presenter.suspendProgress()
        case .canceled:
            //TODO: Show Cancel State
            presenter.showStartButton()
        }
    }
    
    
    
    
    private func setTimer(section: AppTimerSectionState){
        let viewModel : CircularTimerViewModel
        switch section {
        case .ready: viewModel = CircularTimerViewModel(self.detail.ready)
        case .rest: viewModel = CircularTimerViewModel(self.detail.rest)
        case .exercise: viewModel = CircularTimerViewModel(self.detail.exercise)
        case .cycleRest: viewModel = CircularTimerViewModel(self.detail.cycleRest!)
        case .cooldown: viewModel = CircularTimerViewModel(self.detail.cooldown)
        }
        presenter.setTimer(viewModel)
    }
    
        
    private func updateProgress(){
        let remainDuration = timer.remainTime.value
        let progress = remainDuration / timer.totalTime
        presenter.updateProgress(from: progress, remainDuration: remainDuration)
    }
    
    private func removeTimer(){
        AppTimerManager.share.removeTimer(timerId: detail.timerId.uuidString)
    }

}




private extension TimeInterval {
    var time: String {
        return String(format:"%02d:%02d", Int(self/60), Int(ceil(truncatingRemainder(dividingBy: 60))) )
    }
}
 
