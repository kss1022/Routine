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
    
    func showCycleView()
    func hideCycleView()
    
    func setTime(time: String)
    func setCycle(cycle: String)
    func setRound(round: String)
}

protocol TimerRemainListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol TimerRemainInteractorDependency{
    var detail: TimerSectionsModel{ get }
    var timer: AppTimer{ get }
}

final class TimerRemainInteractor: PresentableInteractor<TimerRemainPresentable>, TimerRemainInteractable, TimerRemainPresentableListener {

    weak var router: TimerRemainRouting?
    weak var listener: TimerRemainListener?

    private let dependency: TimerRemainInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    private let detail: TimerSectionsModel
    private let timer: AppTimer
    
    // in constructor.
    init(
        presenter: TimerRemainPresentable,
        dependency: TimerRemainInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        self.detail = dependency.detail
        self.timer = dependency.timer
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
         
        if detail.cycle == nil{
            presenter.hideCycleView()
        }else{
            presenter.showCycleView()
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
        let totalTime = timer.remainTotalTime
        
        let strTotalTime = String(format:"%02d:%02d", Int(totalTime/60), Int(ceil(totalTime.truncatingRemainder(dividingBy: 60))) )
        presenter.setTime(time: strTotalTime)
    }
    
    private func updateRound(){
        let round = "\(self.timer.remainRound)/\(detail.round.count)"
        presenter.setRound(round: round)
    }
    
    private func updateCycle(){
        if let cycle = detail.cycle?.count, let remainCycle = timer.remainCycle{
            let strCycle = "\(remainCycle)/\(cycle)"
            presenter.setCycle(cycle: strCycle)
        }
    }
}
