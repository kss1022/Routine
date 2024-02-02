//
//  RoundRoundTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 1/18/24.
//

import Foundation
import ModernRIBs
import Combine

protocol RoundRoundTimerRouting: ViewableRouting {    
}

protocol RoundRoundTimerPresentable: Presentable {
    var listener: RoundRoundTimerPresentableListener? { get set }
    
    func setTimer(_ viewModel: RoundRoundTimerViewModel)

    
    func showStartButton()
    func showPauseButton()
    func showResumeButton()
    
    func setTime(time: String)
    
    func startProgress(totalDuration: TimeInterval)
    func updateProgress(from: CGFloat,  remainDuration: TimeInterval)    //for restart
    func resumeProgress()
    func suspendProgress()
}

protocol RoundRoundTimerListener: AnyObject {
    func roundRoundDidTapStart()
    func roundRoundDidTapResume()
    func roundRoundDidTapPause()
    func roundRoundDidTapCancle()
}

protocol RoundRoundTimerInteractorDependency{
    var roundTimerSubject: CurrentValueSubject<RoundTimerModel?, Error>{ get }
    var section: ReadOnlyCurrentValuePublisher<TimeSectionModel?>{ get }
    
    var time: ReadOnlyCurrentValuePublisher<TimeInterval>{ get }
    var state: ReadOnlyCurrentValuePublisher<TimerState>{ get }
}

final class RoundRoundTimerInteractor: PresentableInteractor<RoundRoundTimerPresentable>, RoundRoundTimerInteractable, RoundRoundTimerPresentableListener {

    weak var router: RoundRoundTimerRouting?
    weak var listener: RoundRoundTimerListener?

    private let dependency: RoundRoundTimerInteractorDependency
    
    
    private let section: ReadOnlyCurrentValuePublisher<TimeSectionModel?>
    private let state: ReadOnlyCurrentValuePublisher<TimerState>
    private let time: ReadOnlyCurrentValuePublisher<TimeInterval>
    
    private var cancellables: Set<AnyCancellable>

    
    private let model: RoundTimerModel!
    private var isStart: Bool
    
    // in constructor.
    init(
        presenter: RoundRoundTimerPresentable,
        dependency: RoundRoundTimerInteractorDependency
    ) {
        self.dependency = dependency
        self.section = dependency.section
        self.time = dependency.time
        self.state = dependency.state
        self.cancellables = .init()
        self.model = dependency.roundTimerSubject.value!
        self.isStart = false
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        self.section
            .compactMap{ $0 }
            .receive(on: DispatchQueue.main)
            .sink { model in
                let viewModel = RoundRoundTimerViewModel(model)
                self.presenter.setTimer(viewModel)
                                
                if self.isStart{
                    let time = self.time.value
                    let progress = time / model.timeInterval()
                    self.presenter.updateProgress(from: progress, remainDuration: time)
                }
            }
            .store(in: &cancellables)

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
                case  .initialized:
                    self.presenter.showStartButton()
                case .resumed:
                    if self.isStart{
                        self.presenter.resumeProgress()
                        self.presenter.showPauseButton()
                        return
                    }
                    self.presenter.startProgress(totalDuration: self.model.ready.timeInterval())
                    self.presenter.showResumeButton()
                    self.isStart = true
                case .suspended:
                    self.presenter.suspendProgress()
                    self.presenter.showResumeButton()
                case .canceled: break
                }
            }
            .store(in: &cancellables)
    }

    
    override func willResignActive() {
        super.willResignActive()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    

    
    func activeButtonDidTap() {
        switch state.value{
        case .initialized: listener?.roundRoundDidTapStart()
        case .suspended: listener?.roundRoundDidTapResume()
        case .resumed: listener?.roundRoundDidTapPause()
        case .canceled: break
        }
    }
    
    func cancelButtonDidTap() {
        listener?.roundRoundDidTapCancle()
    }
}
