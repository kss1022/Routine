//
//  RoutineDataOfMonthInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import Foundation
import ModernRIBs
import Combine

protocol RoutineDataOfMonthRouting: ViewableRouting {
}

protocol RoutineDataOfMonthPresentable: Presentable {
    var listener: RoutineDataOfMonthPresentableListener? { get set }
    func setCompletes(_ dates: Set<Date>)
}

protocol RoutineDataOfMonthListener: AnyObject {
}

protocol RoutineDataOfMonthInteractorDependency{
    var routineRecords: ReadOnlyCurrentValuePublisher<RoutineRecordDatasModel?>{ get }
}

final class RoutineDataOfMonthInteractor: PresentableInteractor<RoutineDataOfMonthPresentable>, RoutineDataOfMonthInteractable, RoutineDataOfMonthPresentableListener {

    weak var router: RoutineDataOfMonthRouting?
    weak var listener: RoutineDataOfMonthListener?

    private let dependency: RoutineDataOfMonthInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: RoutineDataOfMonthPresentable,
        dependency: RoutineDataOfMonthInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.routineRecords
            .compactMap{ $0 }
            .receive(on: DispatchQueue.main)
            .sink { model in
                self.presenter.setCompletes(Set(model.completes.keys))
            }
            .store(in: &cancellables)        
    }

    override func willResignActive() {
        super.willResignActive()
        
        
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }
}
