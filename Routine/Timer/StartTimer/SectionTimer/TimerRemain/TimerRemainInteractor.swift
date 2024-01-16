//
//  TimerRemainInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/24/23.
//

import Foundation
import ModernRIBs
import Combine

protocol TimerRemainRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TimerRemainPresentable: Presentable {
    var listener: TimerRemainPresentableListener? { get set }
    
    func setCycleInfoView(viewModel: TimerCountInfoViewModel)
    func setRoundInfoView(viewModel: TimerCountInfoViewModel)
    
    func setCycle()
    func setRound()
    
    func setTime(time: String)
    func setCycle(cycle: Int)
    func setRound(round: Int)
}

protocol TimerRemainListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol TimerRemainInteractorDependency{
    var model: SectionTimerModel{ get }
    var timer: AppTimer{ get }
}

final class TimerRemainInteractor: PresentableInteractor<TimerRemainPresentable>, TimerRemainInteractable, TimerRemainPresentableListener {

    weak var router: TimerRemainRouting?
    weak var listener: TimerRemainListener?

    private let dependency: TimerRemainInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    private let model: SectionTimerModel
    private let timer: AppTimer
    
    // in constructor.
    init(
        presenter: TimerRemainPresentable,
        dependency: TimerRemainInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        self.model = dependency.model
        self.timer = dependency.timer
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
         
        if model.cycle != nil{
            
            presenter.setCycle()
            presenter.setCycleInfoView(
                viewModel: TimerCountInfoViewModel(
                    emoji: "🔄",
                    title: "cycle".localized(tableName: "Timer"),
                    count: timer.remainCycle!,
                    totalCount: model.cycle!.count
                )
            )
            presenter.setRoundInfoView(
                viewModel: TimerCountInfoViewModel(
                    emoji: "⛳️",
                    title: "round".localized(tableName: "Timer"),
                    count: timer.remainRound,
                    totalCount: model.round.count
                )
            )
            
        }else{
            presenter.setRound()
            presenter.setRoundInfoView(
                viewModel: TimerCountInfoViewModel(
                    emoji: "⛳️",
                    title: "round".localized(tableName: "Timer"),
                    count: timer.remainRound,
                    totalCount: model.round.count
                )
            )
        }
        
        timer.remainTime
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.updateTimer()
            }
            .store(in: &cancellables)
        
        timer.sectionState
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.updateRound()
                self.updateCycle()
            }
            .store(in: &cancellables)
        
    }
    
    

    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }
    
    private func updateTimer(){
        presenter.setTime(time: timer.remainTotalTime.time)
    }
    
    private func updateRound(){
        presenter.setRound(round: self.timer.remainRound)
    }
    
    private func updateCycle(){
        if let _ = model.cycle?.count, let remainCycle = timer.remainCycle{            
            presenter.setCycle(cycle: remainCycle)
        }
    }
}
