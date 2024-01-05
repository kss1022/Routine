//
//  RoutineTotalRecordInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import Foundation
import ModernRIBs
import Combine

protocol RoutineTotalRecordRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineTotalRecordPresentable: Presentable {
    var listener: RoutineTotalRecordPresentableListener? { get set }
    func setRecords(viewModels: [RoutineTotalRecordListViewModel])
}

protocol RoutineTotalRecordListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol RoutineTotalRecordInteractorDependency{
    var routineRecords: ReadOnlyCurrentValuePublisher<RoutineRecordDatasModel?>{ get }
}

final class RoutineTotalRecordInteractor: PresentableInteractor<RoutineTotalRecordPresentable>, RoutineTotalRecordInteractable, RoutineTotalRecordPresentableListener {

    weak var router: RoutineTotalRecordRouting?
    weak var listener: RoutineTotalRecordListener?

    private let dependency: RoutineTotalRecordInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: RoutineTotalRecordPresentable,
        dependency: RoutineTotalRecordInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        dependency.routineRecords
            .receive(on: DispatchQueue.main)
            .compactMap{ $0 }
            .sink { model in
                let viewModels = [
                    RoutineTotalRecordListViewModel(
                        title: "done_this_month".localized(tableName: "Record"),
                        done: "\(model.doneThisMonth)"
                    ),
                    RoutineTotalRecordListViewModel(
                        title: "totalDone".localized(tableName: "Record"),
                        done: "\(model.totalDone)"
                    ),
                    RoutineTotalRecordListViewModel(
                        title: "current_streak".localized(tableName: "Record"),
                        done: "\(model.currentStreak)"
                    ),
                    RoutineTotalRecordListViewModel(
                        title: "best_streak".localized(tableName: "Record"),
                        done: "\(model.bestStreak)"
                    ),
//                    RoutineTotalRecordListViewModel(
//                        title: "OverallRate",
//                        done: "\(model.bestStreak)%"   //String(format: "%.1f%%", model.overalRate)
//                    ),
                ]
                
                self.presenter.setRecords(viewModels: viewModels)
            }
            .store(in: &cancellables)
        
        
    }

    override func willResignActive() {
        super.willResignActive()
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }
}
