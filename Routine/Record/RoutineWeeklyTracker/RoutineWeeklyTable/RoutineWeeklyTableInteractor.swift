//
//  RoutineWeeklyTableInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import Foundation
import ModernRIBs
import Combine

protocol RoutineWeeklyTableRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineWeeklyTablePresentable: Presentable {
    var listener: RoutineWeeklyTablePresentableListener? { get set }
    func setTableData(_ columns: [RoutineWeeklyTableColumnViewModel] , dataEntys: [WeeklyRange: [RoutineWeeklyTableDataEntryViewModel]])
}

protocol RoutineWeeklyTableListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol RoutineWeeklyTableInteractorDependency{
    var routines: ReadOnlyCurrentValuePublisher<[RecordRoutineListModel]>{ get }
    var routineWeeks: ReadOnlyCurrentValuePublisher<[RoutineWeekRecordModel]>{ get }
}

final class RoutineWeeklyTableInteractor: PresentableInteractor<RoutineWeeklyTablePresentable>, RoutineWeeklyTableInteractable, RoutineWeeklyTablePresentableListener {

    weak var router: RoutineWeeklyTableRouting?
    weak var listener: RoutineWeeklyTableListener?

    private let dependency: RoutineWeeklyTableInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: RoutineWeeklyTablePresentable,
        dependency: RoutineWeeklyTableInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
  
   
        
        dependency.routines
            .combineLatest(dependency.routineWeeks)
            .receive(on: DispatchQueue.main)
            .sink { routines, weeks in
                let columns = routines.map(RoutineWeeklyTableColumnViewModel.init)
                let dataEntrys = weeks.map(RoutineWeeklyTableDataEntryViewModel.init)
                let dataDictionary = Dictionary(grouping: dataEntrys) { 
                    WeeklyRange(startOfWeek: $0.startOfWeek, endOfWeek: $0.endOfWeek)
                }
                self.presenter.setTableData(columns, dataEntys: dataDictionary)
            }
            .store(in: &cancellables)        
    }

    override func willResignActive() {
        super.willResignActive()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }

    
//    private func daysBetweenDates(_ startDate: Date, _ endDate: Date) -> Int {
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
//        return components.day ?? 0
//    }

}
