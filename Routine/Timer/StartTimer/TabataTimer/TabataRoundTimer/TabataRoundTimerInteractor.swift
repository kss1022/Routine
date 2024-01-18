//
//  TabataRoundTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import Foundation
import ModernRIBs
import Combine

protocol TabataRoundTimerRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TabataRoundTimerPresentable: Presentable {
    var listener: TabataRoundTimerPresentableListener? { get set }
    
    func setTimer(_ viewModel: TabataRoundTimerViewModel)
    
    func showStartButton()
    func showPauseButton()
    func showResumeButton()
    
    func setTime(time: String)
    
    func startProgress(totalDuration: TimeInterval)
    func updateProgress(from: CGFloat,  remainDuration: TimeInterval)    //for restart
    func resumeProgress()
    func suspendProgress()
}

protocol TabataRoundTimerListener: AnyObject {
    func tabataRoundDidTapStart()
    func tabataRoundDidTapResume()
    func tabataRoundDidTapPause()
    func tabataRoundDidTapCancle()
}

protocol TabataRoundTimerInteractorDependency{
    var tabataTimerSubject: CurrentValueSubject<TabataTimerModel?, Error>{ get }
    var section: ReadOnlyCurrentValuePublisher<TimeSectionModel?>{ get }
    
    var time: ReadOnlyCurrentValuePublisher<TimeInterval>{ get }
    var state: ReadOnlyCurrentValuePublisher<TimerState>{ get }
}

final class TabataRoundTimerInteractor: PresentableInteractor<TabataRoundTimerPresentable>, TabataRoundTimerInteractable, TabataRoundTimerPresentableListener {

    weak var router: TabataRoundTimerRouting?
    weak var listener: TabataRoundTimerListener?

    private let dependency: TabataRoundTimerInteractorDependency
    
    
    private let section: ReadOnlyCurrentValuePublisher<TimeSectionModel?>
    private let state: ReadOnlyCurrentValuePublisher<TimerState>
    private let time: ReadOnlyCurrentValuePublisher<TimeInterval>
    
    private var cancellables: Set<AnyCancellable>

    
    private let model: TabataTimerModel!
    private var isStart: Bool
    
    // in constructor.
    init(
        presenter: TabataRoundTimerPresentable,
        dependency: TabataRoundTimerInteractorDependency
    ) {
        self.dependency = dependency
        self.section = dependency.section
        self.time = dependency.time
        self.state = dependency.state
        self.cancellables = .init()
        self.model = dependency.tabataTimerSubject.value!
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
                let viewModel = TabataRoundTimerViewModel(model)
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
        case .initialized: listener?.tabataRoundDidTapStart()
        case .suspended: listener?.tabataRoundDidTapResume()
        case .resumed: listener?.tabataRoundDidTapPause()
        case .canceled: break
        }        
    }
    
    func cancelButtonDidTap() {
        listener?.tabataRoundDidTapCancle()
    }
}
