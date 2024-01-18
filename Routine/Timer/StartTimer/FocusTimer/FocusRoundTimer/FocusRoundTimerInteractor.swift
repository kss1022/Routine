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
    func setTime(time: String)
    
    func startProgress(totalDuration: TimeInterval)
    func updateProgress(from: CGFloat,  remainDuration: TimeInterval)    //for restart
    func resumeProgress()
    func suspendProgress()
}

protocol FocusRoundTimerListener: AnyObject {
    func foucsRoundTimerDidTapTimer()
    func focusRoundTimerDidLongPressTimer()
}

protocol FocusRoundTimerInteractorDependency{
    var focusTimerSubject: CurrentValueSubject<FocusTimerModel?, Error>{ get }
    var time: ReadOnlyCurrentValuePublisher<TimeInterval>{ get }
    var state: ReadOnlyCurrentValuePublisher<TimerState>{ get }
}

final class FocusRoundTimerInteractor: PresentableInteractor<FocusRoundTimerPresentable>, FocusRoundTimerInteractable, FocusRoundTimerPresentableListener {
    
    weak var router: FocusRoundTimerRouting?
    weak var listener: FocusRoundTimerListener?
    
    private let dependency : FocusRoundTimerInteractorDependency
    
    private let time: ReadOnlyCurrentValuePublisher<TimeInterval>
    private let state: ReadOnlyCurrentValuePublisher<TimerState>
    private var cancellables: Set<AnyCancellable>
    
    private let model: FocusTimerModel!
    private var isStart: Bool
    
    // in constructor.
    init(
        presenter: FocusRoundTimerPresentable,
        dependency: FocusRoundTimerInteractorDependency
    ) {
        self.dependency = dependency
        self.time = dependency.time
        self.state = dependency.state
        self.cancellables = .init()
        self.model = dependency.focusTimerSubject.value!
        self.isStart = false        
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        let viewModel = FocusRoundTimerViewModel(model)
        self.presenter.setTimer(viewModel)
        
        self.time
            .receive(on: DispatchQueue.main)
            .sink { time in
                self.presenter.setTime(time: time.detailTime)
            }
            .store(in: &cancellables)
        
        
        self.state
            .receive(on: DispatchQueue.main)
            .sink{ state in
                switch state{
                case  .initialized, .canceled : break
                case .resumed:
                    if self.isStart{
                        self.presenter.resumeProgress()
                        return
                    }
                    
                    let totalTime = TimeInterval(self.model.minutes).minutes
                    self.presenter.startProgress(totalDuration: totalTime)
                    self.isStart = true
                case .suspended:
                    self.presenter.suspendProgress()
                }
            }
            .store(in: &cancellables)
    }
    
    override func willResignActive() {
        super.willResignActive()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    
    
    func timerDidTap() {
        listener?.foucsRoundTimerDidTapTimer()
    }
    
    func timerDidLongPress() {
        listener?.focusRoundTimerDidLongPressTimer()
    }
    
    
    
    
    // MARK: Private
    //    private func setTimer(){
    //
    //        presenter.setTimer(FocusRoundTimerViewModel(self.model))
    //
    //        switch timer.timerState {
    //        case .initialized:
    //            presenter.showStartButton()
    //        case .resumed:
    //            updateProgress()
    //            presenter.showPauseButton()
    //            presenter.resumeProgress()
    //            listener?.focusRoundTimerDidResume()
    //        case .suspended:
    //            updateProgress()
    //            presenter.showResumeButton()
    //            presenter.suspendProgress()
    //            listener?.focusRoundTimerDidSuspend()
    //        case .canceled:
    //            //TODO: Show Cancel State
    //            presenter.showStartButton()
    //        }
    //    }
    
    
    //    private func updateProgress(){
    //        let remainDuration = timer.remainTime.value
    //        let progress = remainDuration / totalTime
    //        presenter.updateProgress(from: progress, remainDuration: remainDuration)
    //    }
    //
    //    private func removeTimer(){
    //        AppTimerManager.shared.removeTimer(id: model.id)
    //    }
    
}
