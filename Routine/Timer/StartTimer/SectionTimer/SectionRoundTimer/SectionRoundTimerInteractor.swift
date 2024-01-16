//
//  SectionRoundTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation
import ModernRIBs
import Combine

protocol SectionRoundTimerRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SectionRoundTimerPresentable: Presentable {
    var listener: SectionRoundTimerPresentableListener? { get set }
    
    func setTimer(_ viewModel: SectionRoundTimerViewModel)
    
    func showStartButton()
    func showPauseButton()
    func showResumeButton()
    
    func updateRemainTime(time: String)
    
    func startProgress(totalDuration: TimeInterval)
    func updateProgress(from: CGFloat,  remainDuration: TimeInterval)    //for restart
    func resumeProgress()
    func suspendProgress()
}

protocol SectionRoundTimerListener: AnyObject {
    func sectionRoundDidTapCancle()
}

protocol SectionRoundTimerInteractorDependency{
    var timer: AppTimer{ get }
    var model: SectionTimerModel{ get }
}

final class SectionRoundTimerInteractor: PresentableInteractor<SectionRoundTimerPresentable>, SectionRoundTimerInteractable, SectionRoundTimerPresentableListener {

    weak var router: SectionRoundTimerRouting?
    weak var listener: SectionRoundTimerListener?

    private let dependency : SectionRoundTimerInteractorDependency
    private var cancellables: Set<AnyCancellable>

    private let timer: AppTimer
    private let model: SectionTimerModel
    
    // in constructor.
    init(
        presenter: SectionRoundTimerPresentable,
        dependency: SectionRoundTimerInteractorDependency
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

        
        self.setTimer()  // set current section
        self.setTimerState() // set current sate
        
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
                // TODO: Set Timer Finish
            }
            .store(in: &cancellables)
        
        self.timer.sectionState
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.setTimer()
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
            removeTimer()
            listener?.sectionRoundDidTapCancle()
        }else{
            listener?.sectionRoundDidTapCancle()
        }
    }
    
    
    
    

    //MARK: Private
    
    private func setTimer(){
        let viewModel : SectionRoundTimerViewModel
        switch timer.sectionState.value {
        case .ready: viewModel = SectionRoundTimerViewModel(self.model.ready)
        case .rest: viewModel = SectionRoundTimerViewModel(self.model.rest)
        case .exercise: viewModel = SectionRoundTimerViewModel(self.model.exercise)
        case .cycleRest: viewModel = SectionRoundTimerViewModel(self.model.cycleRest!)
        case .cooldown: viewModel = SectionRoundTimerViewModel(self.model.cooldown)
        }
        presenter.setTimer(viewModel)
    }
    
    private func setTimerState(){
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
    
    
    
        
    private func updateProgress(){
        let remainDuration = timer.remainTime.value
        let progress = remainDuration / timer.totalTime
        presenter.updateProgress(from: progress, remainDuration: remainDuration)
    }
    
    private func removeTimer(){
        AppTimerManager.shared.removeTimer(id: model.timerId)
    }

}
