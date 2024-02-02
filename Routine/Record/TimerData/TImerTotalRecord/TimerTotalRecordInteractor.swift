//
//  TimerTotalRecordInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import Foundation
import ModernRIBs
import Combine

protocol TimerTotalRecordRouting: ViewableRouting {
}

protocol TimerTotalRecordPresentable: Presentable {
    var listener: TimerTotalRecordPresentableListener? { get set }
    func setRecords(viewModels: [TimerTotalRecordListViewModel])
}

protocol TimerTotalRecordListener: AnyObject {
}

protocol TimerTotalRecordInteractorDependency{
    var timerSummeryModel: ReadOnlyCurrentValuePublisher<TimerSummeryModel?>{ get }
}

final class TimerTotalRecordInteractor: PresentableInteractor<TimerTotalRecordPresentable>, TimerTotalRecordInteractable, TimerTotalRecordPresentableListener {

    weak var router: TimerTotalRecordRouting?
    weak var listener: TimerTotalRecordListener?

    private let dependency: TimerTotalRecordInteractorDependency
    private let timerSummeryModel: ReadOnlyCurrentValuePublisher<TimerSummeryModel?>
    
    private var cancellablse: Set<AnyCancellable>
        
    // in constructor.
    init(
        presenter: TimerTotalRecordPresentable,
        dependency: TimerTotalRecordInteractorDependency
    ) {
        self.dependency = dependency
        self.timerSummeryModel = dependency.timerSummeryModel
        self.cancellablse = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        timerSummeryModel.compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { summery in
                
                
                let viewModels = [
                    TimerTotalRecordListViewModel(
                        title: "totalDone".localized(tableName: "Record"),
                        done: "\(summery.totalDone)"
                    ),
                    TimerTotalRecordListViewModel(
                        title: "totalTime".localized(tableName: "Record"),
                        done: Formatter.timerIntervalFormatter(summery.totalTime)
                    ),
                    TimerTotalRecordListViewModel(
                        title: "current_streak".localized(tableName: "Record"),
                        done: "\(summery.currentStreak)"
                    ),
                    TimerTotalRecordListViewModel(
                        title: "best_streak".localized(tableName: "Record"),
                        done: "\(summery.topStreak)"
                    )
                ]
                self.presenter.setRecords(viewModels: viewModels)
            }
            .store(in: &cancellablse)

    }

    override func willResignActive() {
        super.willResignActive()
        
        
        cancellablse.forEach { $0.cancel() }
        cancellablse.removeAll()
    }
  
}
