//
//  RoutineDataOfYearInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import Foundation
import ModernRIBs
import Combine

protocol RoutineDataOfYearRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineDataOfYearPresentable: Presentable {
    var listener: RoutineDataOfYearPresentableListener? { get set }
    func setComplets(year: Int,  dates: Set<Date>)
}

protocol RoutineDataOfYearListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol RoutineDataOfYearInteractorDependency{
    var routineRecords: ReadOnlyCurrentValuePublisher<RoutineRecordDatasModel?>{ get }
}

final class RoutineDataOfYearInteractor: PresentableInteractor<RoutineDataOfYearPresentable>, RoutineDataOfYearInteractable, RoutineDataOfYearPresentableListener {

    weak var router: RoutineDataOfYearRouting?
    weak var listener: RoutineDataOfYearListener?

    
    private let dependency: RoutineDataOfYearInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    private var year: Int
    
    // in constructor.
    init(
        presenter: RoutineDataOfYearPresentable,
        dependency: RoutineDataOfYearInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        
        let today = Date()
        self.year = Calendar.current.component(.year, from: today)
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        dependency.routineRecords
            .receive(on: DispatchQueue.main)
            .compactMap{ $0 }
            .sink { model in
                self.presenter.setComplets(year: self.year, dates: Set(model.completes.keys))
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }
    
    func leftButtonDidTap() {
        guard let model = dependency.routineRecords.value else { return }
        
        self.year -= 1
        
        self.presenter.setComplets(year: self.year, dates: Set(model.completes.keys))
    }
    
    func rightButtonDidTap() {
        guard let model = dependency.routineRecords.value else { return }        
        self.year += 1
        self.presenter.setComplets(year: self.year, dates: Set(model.completes.keys))
    }
}
