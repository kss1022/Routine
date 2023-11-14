//
//  RoutineDataOfWeekInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import Foundation
import ModernRIBs
import Combine

protocol RoutineDataOfWeekRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineDataOfWeekPresentable: Presentable {
    var listener: RoutineDataOfWeekPresentableListener? { get set }
    func setCompletes(_ viewModels: RoutineDataOfWeekListViewModel)
}

protocol RoutineDataOfWeekListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol RoutineDataOfWeekInteractorDependency{
    var routineRecords: ReadOnlyCurrentValuePublisher<RoutineRecordModel?>{ get }
}


final class RoutineDataOfWeekInteractor: PresentableInteractor<RoutineDataOfWeekPresentable>, RoutineDataOfWeekInteractable, RoutineDataOfWeekPresentableListener {

    weak var router: RoutineDataOfWeekRouting?
    weak var listener: RoutineDataOfWeekListener?

    private let dependency: RoutineDataOfWeekInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: RoutineDataOfWeekPresentable,
        dependency: RoutineDataOfWeekInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        
        dependency.routineRecords
            .receive(on: DispatchQueue.main)
            .compactMap{ $0 }
            .sink { records in
                
                let now = Date()
                
                let viewModels = RoutineDataOfWeekListViewModel(
                    dates: self.getDatesForWeek(date: now),
                    model: records.doneThisWeek,
                    imageName: "checkmark.circle.fill", 
                    imageTintColor: "#3BD2AEff"
                )
                self.presenter.setCompletes(viewModels)
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }
    
    
    private func getDatesForWeek(date: Date) -> [Date] {
        let calendar = Calendar.current
        var datesInThisWeek: [Date] = []
        
        //First day of the week  ( sunday )
        //let beginningOfWeek = calendar.date(byAdding: .day, value: 1, to: startOfWeek)
        if let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)){
            //Append Weeks
            for i in 0..<7 {
                if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                    datesInThisWeek.append(date)
                }
            }
        }else{
            Log.e("Can't get first day of the week")
        }
        
        
        return datesInThisWeek
    }

}
