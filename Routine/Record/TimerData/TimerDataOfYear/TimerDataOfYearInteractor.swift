//
//  TimerDataOfYearInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import Foundation
import ModernRIBs
import Combine

protocol TimerDataOfYearRouting: ViewableRouting {
}

protocol TimerDataOfYearPresentable: Presentable {
    var listener: TimerDataOfYearPresentableListener? { get set }
    func setComplets(year: Int, dates: Set<Date>)
}

protocol TimerDataOfYearListener: AnyObject {
}

protocol TimerDataOfYearInteractorDependency{
    var timerRecords: ReadOnlyCurrentValuePublisher<[TimerRecordModel]>{ get }
}

final class TimerDataOfYearInteractor: PresentableInteractor<TimerDataOfYearPresentable>, TimerDataOfYearInteractable, TimerDataOfYearPresentableListener {

    weak var router: TimerDataOfYearRouting?
    weak var listener: TimerDataOfYearListener?

    private let dependency: TimerDataOfYearInteractorDependency
    private let timerRecords: ReadOnlyCurrentValuePublisher<[TimerRecordModel]>
    private var datas: Set<Date>
     
    private var cancellables: Set<AnyCancellable>
    
    private var year: Int

    
    // in constructor.
    init(
        presenter: TimerDataOfYearPresentable,
        dependency: TimerDataOfYearInteractorDependency
    ) {
        self.dependency = dependency
        self.timerRecords = dependency.timerRecords
        self.cancellables = .init()
        
        let today = Date()
        self.year = Calendar.current.component(.year, from: today)
        self.datas = .init()
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
                
        timerRecords.receive(on: DispatchQueue.main)
            .sink { records in
                let formatter = Formatter.recordDateFormatter()
                let dates = records.compactMap { formatter.date(from: $0.recordDate) }
                self.datas = Set(dates)
                self.presenter.setComplets(year: self.year, dates: self.datas)
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func leftButtonDidTap() {
        self.year -= 1
        let dates = timerRecords.value.map { $0.recordDate }
        self.presenter.setComplets(year: self.year, dates: self.datas)
    }
    
    func rightButtonDidTap() {
        self.year += 1
        let dates = timerRecords.value.map { $0.recordDate }
        self.presenter.setComplets(year: self.year, dates: self.datas)
    }
}
