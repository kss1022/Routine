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
    func setCompletes(_ viewModels: [RoutineDataOfWeekViewModel])
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
                let viewModels = RecordCalendar.share.getDatesForThisWeek().map {
                    RoutineDataOfWeekViewModel(
                        date: $0,
                        imageName: "checkmark.circle.fill",
                        done: records.completes[$0] != nil
                    )
                }
                self.presenter.setCompletes(viewModels)
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }
    

}
