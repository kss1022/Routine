//
//  RoundProgressInteractor.swift
//  Routine
//
//  Created by 한현규 on 1/18/24.
//

import Foundation
import ModernRIBs
import Combine

protocol RoundProgressRouting: ViewableRouting {
}

protocol RoundProgressPresentable: Presentable {
    var listener: RoundProgressPresentableListener? { get set }
    
    func setTime(time: String)
    func setRoundInfoView(viewModel: TimerCountInfoViewModel)
}

protocol RoundProgressListener: AnyObject {
}

protocol RoundProgressInteractorDependency{
    var roundTimerSubject: CurrentValueSubject<RoundTimerModel?, Error>{ get}
    var totalTime: ReadOnlyCurrentValuePublisher<TimeInterval>{ get }
    var progress: ReadOnlyCurrentValuePublisher<RoundProgressModel?>{ get }
}

final class RoundProgressInteractor: PresentableInteractor<RoundProgressPresentable>, RoundProgressInteractable, RoundProgressPresentableListener {

    weak var router: RoundProgressRouting?
    weak var listener: RoundProgressListener?
    
    private let dependency: RoundProgressInteractorDependency

    private let totalTime: ReadOnlyCurrentValuePublisher<TimeInterval>
    private let progress: ReadOnlyCurrentValuePublisher<RoundProgressModel?>
    private var cancellables: Set<AnyCancellable>
    
    private let model: RoundTimerModel
    
    // in constructor.
    init(
        presenter: RoundProgressPresentable,
        dependency: RoundProgressInteractorDependency
    ) {
        self.dependency = dependency
        self.totalTime = dependency.totalTime
        self.progress = dependency.progress
        self.model = dependency.roundTimerSubject.value!
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
              
                
                self.presenter.setRoundInfoView(viewModel: round)
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
                
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }
}
