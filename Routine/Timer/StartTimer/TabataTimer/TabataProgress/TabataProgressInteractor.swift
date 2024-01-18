//
//  TabataProgressInteractor.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import Foundation
import ModernRIBs
import Combine

protocol TabataProgressRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TabataProgressPresentable: Presentable {
    var listener: TabataProgressPresentableListener? { get set }
    
    func setTime(time: String)
    func setCycleInfoView(viewModel: TimerCountInfoViewModel)
    func setRoundInfoView(viewModel: TimerCountInfoViewModel)
}

protocol TabataProgressListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol TabataProgressInteractorDependency{
    var tabataTimerSubject: CurrentValueSubject<TabataTimerModel?, Error>{ get}
    var totalTime: ReadOnlyCurrentValuePublisher<TimeInterval>{ get }
    var progress: ReadOnlyCurrentValuePublisher<TabataProgressModel?>{ get }
}

final class TabataProgressInteractor: PresentableInteractor<TabataProgressPresentable>, TabataProgressInteractable, TabataProgressPresentableListener {

    weak var router: TabataProgressRouting?
    weak var listener: TabataProgressListener?

    private let dependency:  TabataProgressInteractorDependency
    
    private let totalTime: ReadOnlyCurrentValuePublisher<TimeInterval>
    private let progress: ReadOnlyCurrentValuePublisher<TabataProgressModel?>
    private var cancellables: Set<AnyCancellable>
    
    private let model: TabataTimerModel
    
    // in constructor.
    init(
        presenter: TabataProgressPresentable,
        dependency:  TabataProgressInteractorDependency
    ) {
        self.dependency = dependency
        self.totalTime = dependency.totalTime
        self.progress = dependency.progress
        self.model = dependency.tabataTimerSubject.value!
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        totalTime
            .receive(on: DispatchQueue.main)
            .sink { time in
                self.presenter.setTime(time: time.time)
            }
            .store(in: &cancellables)
            
        
        progress
            .compactMap{ $0 }
            .receive(on: DispatchQueue.main)
            .sink { progress in
                
                let round = TimerCountInfoViewModel(
                    emoji: "⛳️",
                    title: "round".localized(tableName: "Timer"),
                    count: progress.roundRepeat,
                    totalCount: self.model.round.repeat
                )
                
                let cycle = TimerCountInfoViewModel(
                    emoji: "🔄",
                    title: "cycle".localized(tableName: "Timer"),
                    count: progress.cycleRepeat,
                    totalCount: self.model.cycle.repeat
                )
                
                self.presenter.setRoundInfoView(viewModel: round)
                self.presenter.setCycleInfoView(viewModel: cycle)
            }
            .store(in: &cancellables)
    }
    
    

    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }
    
}
