//
//  TimerNextSectionInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation
import ModernRIBs
import Combine

protocol TimerNextSectionRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TimerNextSectionPresentable: Presentable {
    var listener: TimerNextSectionPresentableListener? { get set }
    func setNextSection(_ viewModel: TimerNextSectionViewModel)
    func removeNextSection()
}

protocol TimerNextSectionListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol TimerNextSectionInteractorDependency{    
    var timer: AppTimer{ get }
    var model: BaseTimerModel{ get }
    var detail: TimerDetailModel{ get }
}

final class TimerNextSectionInteractor: PresentableInteractor<TimerNextSectionPresentable>, TimerNextSectionInteractable, TimerNextSectionPresentableListener {

    weak var router: TimerNextSectionRouting?
    weak var listener: TimerNextSectionListener?

    private let dependency: TimerNextSectionInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    private let timer: AppTimer
    private let model: BaseTimerModel
    private let detail: TimerDetailModel
    
    // in constructor.
    init(
        presenter: TimerNextSectionPresentable,
        dependency: TimerNextSectionInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        self.timer = dependency.timer
        self.model = dependency.model
        self.detail = dependency.detail
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        let section = timer.sectionState.value
        let remainRound = timer.remainRound
        let remainCycle = timer.remainCycle
        setNextSection(section: section, remainRound: remainRound, remainCycle: remainCycle)
        
        timer.sectionState
            .receive(on: DispatchQueue.main)
            .sink { section in
                self.setNextSection(section: section, remainRound: self.timer.remainRound, remainCycle: self.timer.remainCycle)
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    private func setNextSection(section: AppTimerSectionState, remainRound: Int, remainCycle: Int?){
                        
        let viewModel: TimerNextSectionViewModel
        switch section {
        case .ready: 
            viewModel = TimerNextSectionViewModel(self.model.exercise)
            presenter.setNextSection(viewModel)
        case .exercise:
            viewModel = TimerNextSectionViewModel(self.model.rest)
            presenter.setNextSection(viewModel)
        case .rest:
            if remainRound == 0{
                if remainCycle == nil || remainCycle == 0{
                    viewModel = TimerNextSectionViewModel(self.model.cooldown)
                    presenter.setNextSection(viewModel)
                    return
                }
            }
            
            viewModel = TimerNextSectionViewModel(self.model.exercise)
            presenter.setNextSection(viewModel)
            return
        case .cycleRest:
            if remainCycle == 0{
                viewModel = TimerNextSectionViewModel(self.model.cooldown)
                presenter.setNextSection(viewModel)
                return
            }
            
            viewModel = TimerNextSectionViewModel(self.model.exercise)
            presenter.setNextSection(viewModel)
        case .cooldown:
            presenter.removeNextSection()
        }
    }
}
