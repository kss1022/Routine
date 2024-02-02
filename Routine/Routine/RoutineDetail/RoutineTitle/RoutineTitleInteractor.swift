//
//  RoutineTitleInteractor.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import Foundation
import ModernRIBs
import Combine

protocol RoutineTitleRouting: ViewableRouting {
}

protocol RoutineTitlePresentable: Presentable {
    var listener: RoutineTitlePresentableListener? { get set }
    
    func setRoutineTitle(_ viewModel: RoutineTitleViewModel)
    func setIsComplete(_ isComplete: Bool)
}

protocol RoutineTitleListener: AnyObject {
    func routineTitleCompleteButtonDidTap()
}


protocol RoutineTitleInteractorDependency{
    var routineDetail: ReadOnlyCurrentValuePublisher<RoutineDetailModel?>{ get }
    var routineDetailRecord: ReadOnlyCurrentValuePublisher<RoutineDetailRecordModel?>{ get }
}

final class RoutineTitleInteractor: PresentableInteractor<RoutineTitlePresentable>, RoutineTitleInteractable, RoutineTitlePresentableListener {

    weak var router: RoutineTitleRouting?
    weak var listener: RoutineTitleListener?

    private let dependency: RoutineTitleInteractorDependency
    private var cancelables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: RoutineTitlePresentable,
        dependency: RoutineTitleInteractorDependency
    ) {
        self.dependency = dependency
        self.cancelables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
                
        dependency.routineDetail
            .receive(on: DispatchQueue.main)
            .sink { detail in
                if let viewModel =  detail.map(RoutineTitleViewModel.init){
                    self.presenter.setRoutineTitle(viewModel)
                }
            }
            .store(in: &cancelables)
        
        dependency.routineDetailRecord
            .receive(on: DispatchQueue.main)
            .sink {
                if let record = $0{
                    self.presenter.setIsComplete(record.isComplete)
                }
            }
            .store(in: &cancelables)
    }

    override func willResignActive() {
        super.willResignActive()
        cancelables.forEach { $0.cancel() }
        cancelables.removeAll()
    }
    
    func completeButtonDidTap() {
        self.listener?.routineTitleCompleteButtonDidTap()
    }
}
